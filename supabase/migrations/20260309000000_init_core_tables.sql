-- tenants: photographer studio/business accounts
CREATE TABLE public.tenants (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT        NOT NULL,
  slug        TEXT        UNIQUE NOT NULL,
  branding    JSONB       NOT NULL DEFAULT '{}',
  domain      TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- users: links auth.users to a tenant with a role
CREATE TABLE public.users (
  id          UUID        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  tenant_id   UUID        NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  role        TEXT        NOT NULL DEFAULT 'client'
                          CHECK (role IN ('photographer', 'client', 'admin')),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- profiles: public display data per user
CREATE TABLE public.profiles (
  id           UUID        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  avatar_url   TEXT,
  email        TEXT,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE public.tenants  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Basic RLS policies (will be extended in M1-S3)

-- Tenants: only members of the tenant can read their tenant row
CREATE POLICY "Tenant members can view their tenant"
  ON public.tenants FOR SELECT
  USING (
    id IN (
      SELECT tenant_id FROM public.users
      WHERE id = auth.uid()
    )
  );

-- Users: users can only see rows belonging to the same tenant
CREATE POLICY "Users can view users in their tenant"
  ON public.users FOR SELECT
  USING (
    tenant_id IN (
      SELECT tenant_id FROM public.users
      WHERE id = auth.uid()
    )
  );

-- Profiles: authenticated users can view all profiles (public display data)
CREATE POLICY "Authenticated users can view profiles"
  ON public.profiles FOR SELECT
  TO authenticated
  USING (true);

-- Profiles: users can only update their own profile
CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (id = auth.uid());
