import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const GOOGLE_CLIENT_ID = Deno.env.get('DC_GOOGLE_CLIENT_ID')!
const GOOGLE_CLIENT_SECRET = Deno.env.get('DC_GOOGLE_CLIENT_SECRET')!
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

serve(async (req) => {
  const headers = { 'Content-Type': 'application/json' }

  try {
    const body = await req.json()
    const { session_id, action } = body as { session_id: string; action: 'create' | 'update' | 'delete' }

    if (!session_id || !action) {
      return new Response(JSON.stringify({ error: 'Missing session_id or action' }), {
        status: 400, headers,
      })
    }

    // Fetch session details
    const { data: session, error: sessionError } = await supabase
      .from('sessions')
      .select(`
        id, tenant_id, scheduled_at, location, type,
        clients!inner(first_name, last_name)
      `)
      .eq('id', session_id)
      .single()

    if (sessionError || !session) {
      return new Response(JSON.stringify({ error: 'Session not found' }), { status: 404, headers })
    }

    const tenantId = session.tenant_id as string

    // Fetch Google Calendar connection
    const { data: conn, error: connError } = await supabase
      .from('google_calendar_connections')
      .select('*')
      .eq('tenant_id', tenantId)
      .eq('sync_enabled', true)
      .maybeSingle()

    if (connError || !conn) {
      // No active connection, skip silently
      return new Response(JSON.stringify({ success: true, skipped: true }), { headers })
    }

    // Refresh token if needed
    let token = conn.access_token as string
    if (new Date(conn.token_expires_at as string) <= new Date(Date.now() + 60_000)) {
      token = await refreshAccessToken(conn.refresh_token as string)
      await supabase
        .from('google_calendar_connections')
        .update({
          access_token: token,
          token_expires_at: new Date(Date.now() + 3600_000).toISOString(),
        })
        .eq('tenant_id', tenantId)
    }

    const calendarId = (conn.calendar_id as string) || 'primary'
    const client = (session as Record<string, unknown>).clients as Record<string, string>
    const scheduledAt = session.scheduled_at as string
    const endAt = new Date(new Date(scheduledAt).getTime() + 3600_000).toISOString()

    const eventBody = {
      summary: `${client.first_name} ${client.last_name} — ${session.type}`,
      location: (session as Record<string, unknown>).location,
      start: { dateTime: scheduledAt },
      end: { dateTime: endAt },
    }

    const { data: existing } = await supabase
      .from('session_google_sync')
      .select('google_event_id')
      .eq('session_id', session_id)
      .maybeSingle()

    if (action === 'delete' && existing?.google_event_id) {
      await fetch(
        `https://www.googleapis.com/calendar/v3/calendars/${encodeURIComponent(calendarId)}/events/${existing.google_event_id}`,
        { method: 'DELETE', headers: { Authorization: `Bearer ${token}` } },
      )
      await supabase.from('session_google_sync').delete().eq('session_id', session_id)
      return new Response(JSON.stringify({ success: true }), { headers })
    }

    if (action === 'update' && existing?.google_event_id) {
      await fetch(
        `https://www.googleapis.com/calendar/v3/calendars/${encodeURIComponent(calendarId)}/events/${existing.google_event_id}`,
        {
          method: 'PUT',
          headers: {
            Authorization: `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(eventBody),
        },
      )
      await supabase
        .from('session_google_sync')
        .update({ last_synced_at: new Date().toISOString() })
        .eq('session_id', session_id)
      return new Response(JSON.stringify({ success: true }), { headers })
    }

    // create (or fallback from update with no existing)
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
          session_id,
          tenant_id: tenantId,
          google_event_id: created.id,
          last_synced_at: new Date().toISOString(),
        }, { onConflict: 'session_id' })
    }

    return new Response(JSON.stringify({ success: true }), { headers })
  } catch (err) {
    return new Response(JSON.stringify({ error: String(err) }), { status: 500, headers })
  }
})
