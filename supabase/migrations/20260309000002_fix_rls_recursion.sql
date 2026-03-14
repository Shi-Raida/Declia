-- Fix infinite recursion in RLS policies on public.users and public.tenants.
--
-- The original policies queried public.users inside a policy ON public.users,
-- causing infinite recursion. A SECURITY DEFINER function bypasses RLS when
-- resolving the current user's tenant_id, breaking the cycle.

-- Helper: returns the current user's tenant_id without triggering RLS
CREATE OR REPLACE FUNCTION public.current_user_tenant_id()
RETURNS UUID
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $$
  SELECT tenant_id FROM public.users WHERE id = auth.uid();
$$;

-- Tenants
DROP POLICY IF EXISTS "Tenant members can view their tenant" ON public.tenants;
CREATE POLICY "Tenant members can view their tenant"
  ON public.tenants FOR SELECT
  USING (id = public.current_user_tenant_id());

-- Users
DROP POLICY IF EXISTS "Users can view users in their tenant" ON public.users;
CREATE POLICY "Users can view users in their tenant"
  ON public.users FOR SELECT
  USING (tenant_id = public.current_user_tenant_id());
