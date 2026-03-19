import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const GOOGLE_CLIENT_ID = Deno.env.get('GOOGLE_CLIENT_ID')!
const GOOGLE_CLIENT_SECRET = Deno.env.get('GOOGLE_CLIENT_SECRET')!
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

async function refreshAccessToken(refreshToken: string): Promise<string> {
  const res = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      refresh_token: refreshToken,
      client_id: GOOGLE_CLIENT_ID,
      client_secret: GOOGLE_CLIENT_SECRET,
      grant_type: 'refresh_token',
    }),
  })
  const data = await res.json()
  return data.access_token as string
}

async function getValidToken(conn: {
  access_token: string
  refresh_token: string
  token_expires_at: string
  tenant_id: string
}): Promise<string> {
  if (new Date(conn.token_expires_at) > new Date(Date.now() + 60_000)) {
    return conn.access_token
  }
  const newToken = await refreshAccessToken(conn.refresh_token)
  const expiresAt = new Date(Date.now() + 3600 * 1000).toISOString()
  await supabase
    .from('google_calendar_connections')
    .update({ access_token: newToken, token_expires_at: expiresAt })
    .eq('tenant_id', conn.tenant_id)
  return newToken
}

async function syncGoogleToDeclia(conn: Record<string, unknown>, token: string) {
  const tenantId = conn.tenant_id as string
  const calendarId = (conn.calendar_id as string) || 'primary'
  const syncToken = conn.sync_token as string | null

  const params = new URLSearchParams({
    singleEvents: 'true',
    maxResults: '250',
  })
  if (syncToken) {
    params.set('syncToken', syncToken)
  } else {
    // Initial sync: last 30 days + next 90 days
    const timeMin = new Date(Date.now() - 30 * 86400_000).toISOString()
    const timeMax = new Date(Date.now() + 90 * 86400_000).toISOString()
    params.set('timeMin', timeMin)
    params.set('timeMax', timeMax)
  }

  const res = await fetch(
    `https://www.googleapis.com/calendar/v3/calendars/${encodeURIComponent(calendarId)}/events?${params}`,
    { headers: { Authorization: `Bearer ${token}` } },
  )

  if (res.status === 410) {
    // Sync token expired — clear it and do full sync next time
    await supabase
      .from('google_calendar_connections')
      .update({ sync_token: null })
      .eq('tenant_id', tenantId)
    return
  }

  const data = await res.json()
  const items: Record<string, unknown>[] = data.items || []

  for (const item of items) {
    const status = item.status as string
    const googleEventId = item.id as string

    if (status === 'cancelled') {
      await supabase
        .from('external_calendar_events')
        .update({ status: 'cancelled', updated_at: new Date().toISOString() })
        .eq('tenant_id', tenantId)
        .eq('google_event_id', googleEventId)
      continue
    }

    const startObj = item.start as Record<string, string>
    const endObj = item.end as Record<string, string>
    const isAllDay = Boolean(startObj.date)
    const startAt = startObj.dateTime ?? `${startObj.date}T00:00:00Z`
    const endAt = endObj.dateTime ?? `${endObj.date}T23:59:59Z`

    await supabase
      .from('external_calendar_events')
      .upsert({
        tenant_id: tenantId,
        google_event_id: googleEventId,
        title: (item.summary as string) || '(No title)',
        location: item.location as string | null,
        start_at: startAt,
        end_at: endAt,
        is_all_day: isAllDay,
        status,
        source: 'google',
        updated_at: new Date().toISOString(),
      }, { onConflict: 'tenant_id,google_event_id' })
  }

  // Store new sync token
  if (data.nextSyncToken) {
    await supabase
      .from('google_calendar_connections')
      .update({
        sync_token: data.nextSyncToken,
        last_sync_at: new Date().toISOString(),
      })
      .eq('tenant_id', tenantId)
  }
}

async function syncDecliaToGoogle(conn: Record<string, unknown>, token: string) {
  const tenantId = conn.tenant_id as string
  const calendarId = (conn.calendar_id as string) || 'primary'

  // Find sessions not yet synced
  const { data: sessions } = await supabase
    .from('sessions')
    .select(`
      id, scheduled_at, location, type,
      clients!inner(first_name, last_name)
    `)
    .eq('tenant_id', tenantId)
    .not('id', 'in',
      supabase.from('session_google_sync').select('session_id').eq('tenant_id', tenantId),
    )

  for (const session of (sessions || [])) {
    const client = (session as Record<string, unknown>).clients as Record<string, string>
    const scheduledAt = session.scheduled_at as string
    const endAt = new Date(new Date(scheduledAt).getTime() + 3600_000).toISOString()

    const eventBody = {
      summary: `${client.first_name} ${client.last_name} — ${session.type}`,
      location: (session as Record<string, unknown>).location,
      start: { dateTime: scheduledAt },
      end: { dateTime: endAt },
    }

    const res = await fetch(
      `https://www.googleapis.com/calendar/v3/calendars/${encodeURIComponent(calendarId)}/events`,
      {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(eventBody),
      },
    )

    if (res.ok) {
      const created = await res.json()
      await supabase
        .from('session_google_sync')
        .upsert({
          session_id: session.id,
          tenant_id: tenantId,
          google_event_id: created.id,
          last_synced_at: new Date().toISOString(),
        }, { onConflict: 'session_id' })
    }
  }
}

serve(async (_req) => {
  const headers = { 'Content-Type': 'application/json' }

  try {
    // Fetch all active connections
    const { data: connections, error } = await supabase
      .from('google_calendar_connections')
      .select('*')
      .eq('sync_enabled', true)

    if (error) throw error

    for (const conn of (connections || [])) {
      try {
        const token = await getValidToken(conn as {
          access_token: string
          refresh_token: string
          token_expires_at: string
          tenant_id: string
        })
        await syncGoogleToDeclia(conn as Record<string, unknown>, token)
        await syncDecliaToGoogle(conn as Record<string, unknown>, token)
      } catch (connErr) {
        console.error(`Sync failed for tenant ${conn.tenant_id}:`, connErr)
      }
    }

    return new Response(JSON.stringify({ success: true }), { headers })
  } catch (err) {
    return new Response(JSON.stringify({ error: String(err) }), { status: 500, headers })
  }
})
