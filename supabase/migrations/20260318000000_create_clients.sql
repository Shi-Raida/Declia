-- Helper: returns the tenant_id of the currently authenticated user
CREATE OR REPLACE FUNCTION public.current_user_tenant_id()
  RETURNS UUID
  LANGUAGE sql
  SECURITY INVOKER
  STABLE
AS $$
  SELECT tenant_id FROM public.users WHERE id = auth.uid() LIMIT 1;
$$;

-- Clients table
CREATE TABLE IF NOT EXISTS public.clients (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id           UUID        NOT NULL
                                  DEFAULT public.current_user_tenant_id()
                                  REFERENCES public.tenants(id) ON DELETE CASCADE,
  user_id             UUID        REFERENCES auth.users(id) ON DELETE SET NULL,
  first_name          TEXT        NOT NULL,
  last_name           TEXT        NOT NULL,
  email               TEXT,
  phone               TEXT,
  date_of_birth       DATE,
  address             JSONB,
  acquisition_source  TEXT        CHECK (
                                    acquisition_source IN (
                                      'referral',
                                      'social_media',
                                      'website',
                                      'word_of_mouth',
                                      'event',
                                      'other'
                                    )
                                  ),
  tags                TEXT[]      NOT NULL DEFAULT '{}',
  notes               TEXT,
  preferences         JSONB,
  communication_prefs JSONB       NOT NULL
                                  DEFAULT '{"email":false,"sms":false,"phone":false}'::JSONB,
  gdpr_consent_date   TIMESTAMPTZ,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS clients_tenant_id_idx
  ON public.clients (tenant_id);

CREATE UNIQUE INDEX IF NOT EXISTS clients_tenant_email_idx
  ON public.clients (tenant_id, email)
  WHERE email IS NOT NULL;

CREATE INDEX IF NOT EXISTS clients_tags_gin_idx
  ON public.clients USING GIN (tags);

CREATE INDEX IF NOT EXISTS clients_tenant_name_idx
  ON public.clients (tenant_id, last_name, first_name);

-- updated_at trigger (generic, reusable)
CREATE OR REPLACE FUNCTION public.set_updated_at()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

CREATE TRIGGER clients_set_updated_at
  BEFORE UPDATE ON public.clients
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- Row Level Security
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

-- All authenticated tenant members can SELECT
CREATE POLICY "tenant_members_select_clients"
  ON public.clients
  FOR SELECT
  TO authenticated
  USING (
    tenant_id IN (
      SELECT tenant_id FROM public.users WHERE id = auth.uid()
    )
  );

-- Photographers and tech can INSERT
CREATE POLICY "photographers_insert_clients"
  ON public.clients
  FOR INSERT
  TO authenticated
  WITH CHECK (
    tenant_id IN (
      SELECT tenant_id FROM public.users
      WHERE id = auth.uid() AND role IN ('photographer', 'tech')
    )
  );

-- Photographers and tech can UPDATE
CREATE POLICY "photographers_update_clients"
  ON public.clients
  FOR UPDATE
  TO authenticated
  USING (
    tenant_id IN (
      SELECT tenant_id FROM public.users
      WHERE id = auth.uid() AND role IN ('photographer', 'tech')
    )
  );

-- Photographers and tech can DELETE
CREATE POLICY "photographers_delete_clients"
  ON public.clients
  FOR DELETE
  TO authenticated
  USING (
    tenant_id IN (
      SELECT tenant_id FROM public.users
      WHERE id = auth.uid() AND role IN ('photographer', 'tech')
    )
  );

-- Search RPC (SECURITY INVOKER so RLS is applied)
CREATE OR REPLACE FUNCTION public.search_clients(query TEXT)
  RETURNS SETOF public.clients
  LANGUAGE sql
  SECURITY INVOKER
  STABLE
AS $$
  SELECT *
  FROM public.clients
  WHERE
    first_name  ILIKE '%' || query || '%' OR
    last_name   ILIKE '%' || query || '%' OR
    email       ILIKE '%' || query || '%' OR
    phone       ILIKE '%' || query || '%'
  ORDER BY last_name, first_name;
$$;
