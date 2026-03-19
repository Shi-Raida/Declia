-- ============================================================
-- M2-S3: Client History tables
-- ============================================================

-- -------------------------
-- Enum types
-- -------------------------
CREATE TYPE public.session_type AS ENUM (
  'family', 'equestrian', 'event', 'maternity',
  'school', 'portrait', 'mini_session', 'other'
);

CREATE TYPE public.session_status AS ENUM (
  'scheduled', 'confirmed', 'completed', 'cancelled', 'no_show'
);

CREATE TYPE public.payment_status AS ENUM (
  'pending', 'partial', 'paid', 'refunded'
);

CREATE TYPE public.gallery_status AS ENUM (
  'draft', 'published', 'archived', 'expired'
);

CREATE TYPE public.order_status AS ENUM (
  'pending', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded'
);

CREATE TYPE public.communication_channel AS ENUM (
  'email', 'sms'
);

CREATE TYPE public.communication_status AS ENUM (
  'queued', 'sent', 'delivered', 'failed', 'bounced'
);

-- -------------------------
-- sessions
-- -------------------------
CREATE TABLE IF NOT EXISTS public.sessions (
  id               UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id        UUID          NOT NULL
                                 DEFAULT public.current_user_tenant_id()
                                 REFERENCES public.tenants(id) ON DELETE CASCADE,
  client_id        UUID          NOT NULL
                                 REFERENCES public.clients(id) ON DELETE CASCADE,
  type             public.session_type   NOT NULL DEFAULT 'other',
  status           public.session_status NOT NULL DEFAULT 'scheduled',
  scheduled_at     TIMESTAMPTZ   NOT NULL,
  location         TEXT,
  payment_status   public.payment_status NOT NULL DEFAULT 'pending',
  amount           NUMERIC(10,2) NOT NULL DEFAULT 0,
  notes            TEXT,
  created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS sessions_tenant_id_idx
  ON public.sessions (tenant_id);

CREATE INDEX IF NOT EXISTS sessions_tenant_client_idx
  ON public.sessions (tenant_id, client_id);

CREATE TRIGGER sessions_set_updated_at
  BEFORE UPDATE ON public.sessions
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_members_select_sessions"
  ON public.sessions FOR SELECT TO authenticated
  USING (tenant_id IN (SELECT tenant_id FROM public.users WHERE id = auth.uid()));

CREATE POLICY "photographers_insert_sessions"
  ON public.sessions FOR INSERT TO authenticated
  WITH CHECK (tenant_id IN (
    SELECT tenant_id FROM public.users
    WHERE id = auth.uid() AND role IN ('photographer', 'tech')
  ));

CREATE POLICY "photographers_update_sessions"
  ON public.sessions FOR UPDATE TO authenticated
  USING (tenant_id IN (
    SELECT tenant_id FROM public.users
    WHERE id = auth.uid() AND role IN ('photographer', 'tech')
  ));

CREATE POLICY "photographers_delete_sessions"
  ON public.sessions FOR DELETE TO authenticated
  USING (tenant_id IN (
    SELECT tenant_id FROM public.users
    WHERE id = auth.uid() AND role IN ('photographer', 'tech')
  ));

-- -------------------------
-- galleries
-- -------------------------
CREATE TABLE IF NOT EXISTS public.galleries (
  id          UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID          NOT NULL
                            DEFAULT public.current_user_tenant_id()
                            REFERENCES public.tenants(id) ON DELETE CASCADE,
  client_id   UUID          NOT NULL
                            REFERENCES public.clients(id) ON DELETE CASCADE,
  session_id  UUID          REFERENCES public.sessions(id) ON DELETE SET NULL,
  title       TEXT          NOT NULL,
  status      public.gallery_status NOT NULL DEFAULT 'draft',
  url_slug    TEXT,
  photo_count INT           NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS galleries_tenant_id_idx
  ON public.galleries (tenant_id);

CREATE INDEX IF NOT EXISTS galleries_tenant_client_idx
  ON public.galleries (tenant_id, client_id);

CREATE TRIGGER galleries_set_updated_at
  BEFORE UPDATE ON public.galleries
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.galleries ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_members_select_galleries"
  ON public.galleries FOR SELECT TO authenticated
  USING (tenant_id IN (SELECT tenant_id FROM public.users WHERE id = auth.uid()));

CREATE POLICY "photographers_insert_galleries"
  ON public.galleries FOR INSERT TO authenticated
  WITH CHECK (tenant_id IN (
    SELECT tenant_id FROM public.users
    WHERE id = auth.uid() AND role IN ('photographer', 'tech')
  ));

CREATE POLICY "photographers_update_galleries"
  ON public.galleries FOR UPDATE TO authenticated
  USING (tenant_id IN (
    SELECT tenant_id FROM public.users
    WHERE id = auth.uid() AND role IN ('photographer', 'tech')
  ));

CREATE POLICY "photographers_delete_galleries"
  ON public.galleries FOR DELETE TO authenticated
  USING (tenant_id IN (
    SELECT tenant_id FROM public.users
    WHERE id = auth.uid() AND role IN ('photographer', 'tech')
  ));

-- -------------------------
-- orders
-- -------------------------
CREATE TABLE IF NOT EXISTS public.orders (
  id           UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id    UUID          NOT NULL
                             DEFAULT public.current_user_tenant_id()
                             REFERENCES public.tenants(id) ON DELETE CASCADE,
  client_id    UUID          NOT NULL
                             REFERENCES public.clients(id) ON DELETE CASCADE,
  session_id   UUID          REFERENCES public.sessions(id) ON DELETE SET NULL,
  status       public.order_status NOT NULL DEFAULT 'pending',
  total_amount NUMERIC(10,2) NOT NULL DEFAULT 0,
  order_date   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  description  TEXT,
  created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS orders_tenant_id_idx
  ON public.orders (tenant_id);

CREATE INDEX IF NOT EXISTS orders_tenant_client_idx
  ON public.orders (tenant_id, client_id);

CREATE TRIGGER orders_set_updated_at
  BEFORE UPDATE ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_members_select_orders"
  ON public.orders FOR SELECT TO authenticated
  USING (tenant_id IN (SELECT tenant_id FROM public.users WHERE id = auth.uid()));

CREATE POLICY "photographers_insert_orders"
  ON public.orders FOR INSERT TO authenticated
  WITH CHECK (tenant_id IN (
    SELECT tenant_id FROM public.users
    WHERE id = auth.uid() AND role IN ('photographer', 'tech')
  ));

CREATE POLICY "photographers_update_orders"
  ON public.orders FOR UPDATE TO authenticated
  USING (tenant_id IN (
    SELECT tenant_id FROM public.users
    WHERE id = auth.uid() AND role IN ('photographer', 'tech')
  ));

CREATE POLICY "photographers_delete_orders"
  ON public.orders FOR DELETE TO authenticated
  USING (tenant_id IN (
    SELECT tenant_id FROM public.users
    WHERE id = auth.uid() AND role IN ('photographer', 'tech')
  ));

-- -------------------------
-- communication_logs
-- -------------------------
CREATE TABLE IF NOT EXISTS public.communication_logs (
  id         UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id  UUID          NOT NULL
                           DEFAULT public.current_user_tenant_id()
                           REFERENCES public.tenants(id) ON DELETE CASCADE,
  client_id  UUID          NOT NULL
                           REFERENCES public.clients(id) ON DELETE CASCADE,
  channel    public.communication_channel  NOT NULL,
  subject    TEXT,
  status     public.communication_status  NOT NULL DEFAULT 'queued',
  sent_at    TIMESTAMPTZ,
  created_at TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS communication_logs_tenant_id_idx
  ON public.communication_logs (tenant_id);

CREATE INDEX IF NOT EXISTS communication_logs_tenant_client_idx
  ON public.communication_logs (tenant_id, client_id);

ALTER TABLE public.communication_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_members_select_communication_logs"
  ON public.communication_logs FOR SELECT TO authenticated
  USING (tenant_id IN (SELECT tenant_id FROM public.users WHERE id = auth.uid()));

CREATE POLICY "photographers_insert_communication_logs"
  ON public.communication_logs FOR INSERT TO authenticated
  WITH CHECK (tenant_id IN (
    SELECT tenant_id FROM public.users
    WHERE id = auth.uid() AND role IN ('photographer', 'tech')
  ));

-- -------------------------
-- client_summary_stats view
-- -------------------------
CREATE OR REPLACE VIEW public.client_summary_stats
  WITH (security_invoker = true)
AS
SELECT
  c.id                                              AS client_id,
  c.tenant_id,
  COALESCE(s.session_count, 0)                      AS session_count,
  COALESCE(o.total_spent, 0)                        AS total_spent,
  ls.last_shooting
FROM public.clients c
LEFT JOIN LATERAL (
  SELECT COUNT(*) AS session_count
  FROM public.sessions
  WHERE client_id = c.id AND tenant_id = c.tenant_id
) s ON TRUE
LEFT JOIN LATERAL (
  SELECT SUM(total_amount) AS total_spent
  FROM public.orders
  WHERE client_id = c.id
    AND tenant_id = c.tenant_id
    AND status NOT IN ('cancelled', 'refunded')
) o ON TRUE
LEFT JOIN LATERAL (
  SELECT MAX(scheduled_at) AS last_shooting
  FROM public.sessions
  WHERE client_id = c.id
    AND tenant_id = c.tenant_id
    AND status = 'completed'
) ls ON TRUE;
