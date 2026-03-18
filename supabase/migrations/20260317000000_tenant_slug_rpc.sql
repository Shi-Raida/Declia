-- RPC: check whether a tenant with the given slug exists.
-- Callable by anonymous users (for pre-validating registration links).
-- Returns only a boolean — no tenant data is exposed to unauthenticated callers.

CREATE OR REPLACE FUNCTION public.tenant_exists_by_slug(p_slug TEXT)
  RETURNS BOOLEAN
  LANGUAGE sql
  SECURITY DEFINER
  STABLE
  SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.tenants WHERE slug = p_slug
  );
$$;

GRANT EXECUTE ON FUNCTION public.tenant_exists_by_slug(TEXT) TO anon;
GRANT EXECUTE ON FUNCTION public.tenant_exists_by_slug(TEXT) TO authenticated;

-- Patch handle_new_user() to also guard against an empty string slug,
-- not just NULL (belt-and-suspenders alongside the client-side check).
CREATE OR REPLACE FUNCTION public.handle_new_user()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public
AS $$
DECLARE
  v_tenant_slug TEXT;
  v_tenant_id   UUID;
BEGIN
  v_tenant_slug := NEW.raw_user_meta_data->>'tenant_slug';

  -- Guard: no slug (or empty string) means this is not a client self-signup
  IF v_tenant_slug IS NULL OR v_tenant_slug = '' THEN
    RETURN NEW;
  END IF;

  SELECT id INTO v_tenant_id
    FROM public.tenants
   WHERE slug = v_tenant_slug;

  IF v_tenant_id IS NULL THEN
    RAISE EXCEPTION 'Invalid tenant slug: %', v_tenant_slug;
  END IF;

  INSERT INTO public.users (id, tenant_id, role)
    VALUES (NEW.id, v_tenant_id, 'client');

  RETURN NEW;
END;
$$;
