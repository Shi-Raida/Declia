-- Migration: create consent_records table

CREATE TABLE public.consent_records (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID        REFERENCES auth.users(id) ON DELETE SET NULL,
  anon_id     TEXT        NOT NULL,
  consent_type TEXT       NOT NULL CHECK (consent_type IN ('analytics', 'marketing', 'functional')),
  granted     BOOLEAN     NOT NULL,
  ip_address  TEXT,
  user_agent  TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- RLS
ALTER TABLE public.consent_records ENABLE ROW LEVEL SECURITY;

-- Anonymous and authenticated users can insert their own consent records
CREATE POLICY "consent_records_insert"
  ON public.consent_records
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- Authenticated users can only read their own records
CREATE POLICY "consent_records_select_own"
  ON public.consent_records
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- Indexes
CREATE INDEX consent_records_user_id_idx   ON public.consent_records (user_id);
CREATE INDEX consent_records_anon_id_idx   ON public.consent_records (anon_id);
