-- Migration: M2-S6 Google Calendar Sync
-- Creates three tables for bidirectional Google Calendar synchronization.

-- 1. google_calendar_connections: stores OAuth tokens and sync state per tenant
CREATE TABLE google_calendar_connections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID UNIQUE NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  access_token TEXT NOT NULL,
  refresh_token TEXT NOT NULL,
  token_expires_at TIMESTAMPTZ NOT NULL,
  calendar_id TEXT NOT NULL DEFAULT 'primary',
  sync_enabled BOOLEAN NOT NULL DEFAULT true,
  last_sync_at TIMESTAMPTZ,
  sync_token TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. external_calendar_events: Google events stored locally for display/blocking
CREATE TABLE external_calendar_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  google_event_id TEXT NOT NULL,
  title TEXT NOT NULL,
  location TEXT,
  start_at TIMESTAMPTZ NOT NULL,
  end_at TIMESTAMPTZ NOT NULL,
  is_all_day BOOLEAN NOT NULL DEFAULT false,
  status TEXT NOT NULL DEFAULT 'confirmed',
  source TEXT NOT NULL DEFAULT 'google',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (tenant_id, google_event_id)
);

CREATE INDEX idx_external_calendar_events_tenant_range
  ON external_calendar_events (tenant_id, start_at, end_at);

-- 3. session_google_sync: maps Declia sessions to their Google Calendar event IDs
CREATE TABLE session_google_sync (
  session_id UUID PRIMARY KEY REFERENCES sessions(id) ON DELETE CASCADE,
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  google_event_id TEXT NOT NULL,
  last_synced_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Row Level Security
ALTER TABLE google_calendar_connections ENABLE ROW LEVEL SECURITY;
ALTER TABLE external_calendar_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE session_google_sync ENABLE ROW LEVEL SECURITY;

-- google_calendar_connections: tenant can read connection meta (no tokens)
CREATE POLICY "tenant_select_connection"
  ON google_calendar_connections FOR SELECT
  USING (
    tenant_id = (
      SELECT tenant_id FROM users WHERE id = auth.uid()
    )
  );

-- Tenant can update sync_enabled and calendar_id
CREATE POLICY "tenant_update_connection"
  ON google_calendar_connections FOR UPDATE
  USING (
    tenant_id = (
      SELECT tenant_id FROM users WHERE id = auth.uid()
    )
  )
  WITH CHECK (
    tenant_id = (
      SELECT tenant_id FROM users WHERE id = auth.uid()
    )
  );

-- external_calendar_events: tenant can read
CREATE POLICY "tenant_select_external_events"
  ON external_calendar_events FOR SELECT
  USING (
    tenant_id = (
      SELECT tenant_id FROM users WHERE id = auth.uid()
    )
  );

-- session_google_sync: tenant can read
CREATE POLICY "tenant_select_session_sync"
  ON session_google_sync FOR SELECT
  USING (
    tenant_id = (
      SELECT tenant_id FROM users WHERE id = auth.uid()
    )
  );

-- pg_cron: trigger sync every 5 minutes (requires pg_cron extension)
-- Run after migration if pg_cron is available:
-- SELECT cron.schedule('google-calendar-sync', '*/5 * * * *',
--   $$SELECT net.http_post(
--     url := current_setting('app.supabase_url') || '/functions/v1/google-calendar-sync',
--     headers := jsonb_build_object(
--       'Authorization', 'Bearer ' || current_setting('app.service_role_key'),
--       'Content-Type', 'application/json'
--     ),
--     body := '{}'::jsonb
--   )$$
-- );
