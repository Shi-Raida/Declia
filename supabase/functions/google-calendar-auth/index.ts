import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const GOOGLE_CLIENT_ID = Deno.env.get('GOOGLE_CLIENT_ID')!
const GOOGLE_CLIENT_SECRET = Deno.env.get('GOOGLE_CLIENT_SECRET')!
const GOOGLE_REDIRECT_URI = Deno.env.get('GOOGLE_REDIRECT_URI')!
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

const SCOPES = [
  'https://www.googleapis.com/auth/calendar',
  'https://www.googleapis.com/auth/calendar.events',
].join(' ')

serve(async (req) => {
  const headers = { 'Content-Type': 'application/json' }

  try {
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Missing Authorization header' }), {
        status: 401, headers,
      })
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)
    const userSupabase = createClient(SUPABASE_URL, Deno.env.get('SUPABASE_ANON_KEY')!, {
      global: { headers: { Authorization: authHeader } },
    })

    const { data: { user }, error: userError } = await userSupabase.auth.getUser()
    if (userError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401, headers })
    }

    // Get tenant_id for this user
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('tenant_id')
      .eq('id', user.id)
      .single()

    if (profileError || !profile) {
      return new Response(JSON.stringify({ error: 'Profile not found' }), { status: 404, headers })
    }

    const tenantId = profile.tenant_id
    const body = await req.json()
    const action = body.action as string

    switch (action) {
      case 'get_auth_url': {
        const params = new URLSearchParams({
          client_id: GOOGLE_CLIENT_ID,
          redirect_uri: GOOGLE_REDIRECT_URI,
          response_type: 'code',
          scope: SCOPES,
          access_type: 'offline',
          prompt: 'consent',
          state: tenantId,
        })
        const url = `https://accounts.google.com/o/oauth2/v2/auth?${params}`
        return new Response(JSON.stringify({ url }), { headers })
      }

      case 'exchange_code': {
        const code = body.code as string
        if (!code) {
          return new Response(JSON.stringify({ error: 'Missing code' }), { status: 400, headers })
        }

        // Exchange code for tokens
        const tokenRes = await fetch('https://oauth2.googleapis.com/token', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: new URLSearchParams({
            code,
            client_id: GOOGLE_CLIENT_ID,
            client_secret: GOOGLE_CLIENT_SECRET,
            redirect_uri: GOOGLE_REDIRECT_URI,
            grant_type: 'authorization_code',
          }),
        })

        if (!tokenRes.ok) {
          const err = await tokenRes.text()
          return new Response(JSON.stringify({ error: `Token exchange failed: ${err}` }), {
            status: 400, headers,
          })
        }

        const tokens = await tokenRes.json()
        const expiresAt = new Date(Date.now() + tokens.expires_in * 1000).toISOString()

        await supabase
          .from('google_calendar_connections')
          .upsert({
            tenant_id: tenantId,
            access_token: tokens.access_token,
            refresh_token: tokens.refresh_token,
            token_expires_at: expiresAt,
            updated_at: new Date().toISOString(),
          }, { onConflict: 'tenant_id' })

        return new Response(JSON.stringify({ success: true }), { headers })
      }

      case 'disconnect': {
        // Optionally revoke token
        const { data: conn } = await supabase
          .from('google_calendar_connections')
          .select('access_token')
          .eq('tenant_id', tenantId)
          .maybeSingle()

        if (conn?.access_token) {
          await fetch(`https://oauth2.googleapis.com/revoke?token=${conn.access_token}`, {
            method: 'POST',
          }).catch(() => {}) // best-effort
        }

        // Delete connection and external events
        await supabase
          .from('external_calendar_events')
          .delete()
          .eq('tenant_id', tenantId)

        await supabase
          .from('google_calendar_connections')
          .delete()
          .eq('tenant_id', tenantId)

        return new Response(JSON.stringify({ success: true }), { headers })
      }

      case 'status': {
        const { data } = await supabase
          .from('google_calendar_connections')
          .select('id, calendar_id, sync_enabled, last_sync_at, created_at, updated_at')
          .eq('tenant_id', tenantId)
          .maybeSingle()

        return new Response(JSON.stringify({ connection: data }), { headers })
      }

      default:
        return new Response(JSON.stringify({ error: `Unknown action: ${action}` }), {
          status: 400, headers,
        })
    }
  } catch (err) {
    return new Response(JSON.stringify({ error: String(err) }), { status: 500, headers })
  }
})
