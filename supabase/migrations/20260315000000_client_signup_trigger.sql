-- Trigger: auto-create public.users row when a new auth.users row is inserted
-- Only fires when raw_user_meta_data contains a 'tenant_slug' key (client signups).
-- Existing seed users (created without metadata) are unaffected.

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

  -- Guard: no slug means this is not a client self-signup (e.g. seeded users)
  IF v_tenant_slug IS NULL THEN
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

-- Drop existing trigger if any, then recreate
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();
