-- M1-S7: Rename role 'admin' → 'tech' and add role-based RLS policies.

-- 5a. Rename existing 'admin' rows to 'tech', then update the role constraint.
UPDATE public.users SET role = 'tech' WHERE role = 'admin';
ALTER TABLE public.users DROP CONSTRAINT IF EXISTS users_role_check;
ALTER TABLE public.users ADD CONSTRAINT users_role_check
  CHECK (role IN ('photographer', 'client', 'tech'));

-- 5b. Helper: returns the current user's role without triggering RLS (same
--     pattern as current_user_tenant_id in migration 20260309000002).
CREATE OR REPLACE FUNCTION public.current_user_role()
RETURNS TEXT
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $$
  SELECT role FROM public.users WHERE id = auth.uid();
$$;

-- 5c. Role-based RLS on public.users (write operations).
--     Only photographers in the same tenant may insert/update/delete users.
DROP POLICY IF EXISTS "Photographers can insert users in their tenant" ON public.users;
CREATE POLICY "Photographers can insert users in their tenant"
  ON public.users FOR INSERT
  TO authenticated
  WITH CHECK (
    tenant_id = public.current_user_tenant_id() AND
    public.current_user_role() = 'photographer'
  );

DROP POLICY IF EXISTS "Photographers can update users in their tenant" ON public.users;
CREATE POLICY "Photographers can update users in their tenant"
  ON public.users FOR UPDATE
  TO authenticated
  USING (
    tenant_id = public.current_user_tenant_id() AND
    public.current_user_role() = 'photographer'
  );

DROP POLICY IF EXISTS "Photographers can delete users in their tenant" ON public.users;
CREATE POLICY "Photographers can delete users in their tenant"
  ON public.users FOR DELETE
  TO authenticated
  USING (
    tenant_id = public.current_user_tenant_id() AND
    public.current_user_role() = 'photographer'
  );

-- 5d. Role-based RLS on public.tenants (write operations).
--     Only photographers may update their tenant row.
DROP POLICY IF EXISTS "Photographers can update their tenant" ON public.tenants;
CREATE POLICY "Photographers can update their tenant"
  ON public.tenants FOR UPDATE
  TO authenticated
  USING (
    id = public.current_user_tenant_id() AND
    public.current_user_role() = 'photographer'
  );

-- 5e. Update storage policies to allow tech users to upload alongside photographers.

-- gallery-photos: drop old photographer-only policy, recreate for staff (photographer + tech)
DROP POLICY IF EXISTS "Photographers can upload gallery photos" ON storage.objects;
CREATE POLICY "Staff can upload gallery photos"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'gallery-photos' AND
    (storage.foldername(name))[1] IN (
      SELECT tenant_id::text FROM public.users
      WHERE id = auth.uid() AND role IN ('photographer', 'tech')
    )
  );

-- documents: drop old photographer-only policy, recreate for staff (photographer + tech)
DROP POLICY IF EXISTS "Photographers can manage documents" ON storage.objects;
CREATE POLICY "Staff can manage documents"
  ON storage.objects FOR ALL
  TO authenticated
  USING (
    bucket_id = 'documents' AND
    (storage.foldername(name))[1] IN (
      SELECT tenant_id::text FROM public.users
      WHERE id = auth.uid() AND role IN ('photographer', 'tech')
    )
  );
