-- Add company column to clients for professional client distinction
ALTER TABLE public.clients ADD COLUMN IF NOT EXISTS company TEXT;

-- Update search RPC to include company
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
    phone       ILIKE '%' || query || '%' OR
    company     ILIKE '%' || query || '%'
  ORDER BY last_name, first_name;
$$;

-- Update signup trigger to store company from metadata
CREATE OR REPLACE FUNCTION public.handle_new_user()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public
AS $$
DECLARE
  v_tenant_slug  TEXT;
  v_tenant_id    UUID;
  v_role         TEXT;
  v_first_name   TEXT;
  v_last_name    TEXT;
  v_email        TEXT;
  v_phone        TEXT;
  v_studio_name  TEXT;
  v_slug         TEXT;
BEGIN
  v_tenant_slug := NEW.raw_user_meta_data->>'tenant_slug';
  v_role        := NEW.raw_user_meta_data->>'role';
  v_first_name  := NEW.raw_user_meta_data->>'first_name';
  v_last_name   := NEW.raw_user_meta_data->>'last_name';
  v_email       := NEW.email;
  v_phone       := NEW.raw_user_meta_data->>'phone';

  -- ── Photographer path ──
  IF v_role = 'photographer' THEN
    v_studio_name := NEW.raw_user_meta_data->>'studio_name';

    -- Auto-generate slug from studio name
    v_slug := lower(regexp_replace(trim(v_studio_name), '[^a-zA-Z0-9]+', '-', 'g'));
    v_slug := trim(BOTH '-' FROM v_slug);
    -- Ensure uniqueness by appending a random suffix
    IF EXISTS (SELECT 1 FROM public.tenants WHERE slug = v_slug) THEN
      v_slug := v_slug || '-' || substr(gen_random_uuid()::text, 1, 8);
    END IF;

    INSERT INTO public.tenants (name, slug, company_name, siret, legal_form, vat_number, address)
      VALUES (
        v_studio_name,
        v_slug,
        NEW.raw_user_meta_data->>'company_name',
        NEW.raw_user_meta_data->>'siret',
        NEW.raw_user_meta_data->>'legal_form',
        NEW.raw_user_meta_data->>'vat_number',
        CASE WHEN NEW.raw_user_meta_data->'address' IS NOT NULL
             THEN NEW.raw_user_meta_data->'address'
             ELSE NULL
        END
      )
      RETURNING id INTO v_tenant_id;

    INSERT INTO public.users (id, tenant_id, role)
      VALUES (NEW.id, v_tenant_id, 'photographer');

    INSERT INTO public.profiles (id, display_name, email)
      VALUES (NEW.id, trim(coalesce(v_first_name, '') || ' ' || coalesce(v_last_name, '')), v_email);

    RETURN NEW;
  END IF;

  -- ── Client path (tenant_slug present) ──
  IF v_tenant_slug IS NOT NULL THEN
    SELECT id INTO v_tenant_id
      FROM public.tenants
     WHERE slug = v_tenant_slug;

    IF v_tenant_id IS NULL THEN
      RAISE EXCEPTION 'Invalid tenant slug: %', v_tenant_slug;
    END IF;

    INSERT INTO public.users (id, tenant_id, role)
      VALUES (NEW.id, v_tenant_id, 'client');

    INSERT INTO public.profiles (id, display_name, email)
      VALUES (NEW.id, trim(coalesce(v_first_name, '') || ' ' || coalesce(v_last_name, '')), v_email);

    INSERT INTO public.clients (
      tenant_id, user_id, first_name, last_name, email, phone,
      company, address, acquisition_source, notes, gdpr_consent_date,
      communication_prefs
    ) VALUES (
      v_tenant_id,
      NEW.id,
      coalesce(v_first_name, ''),
      coalesce(v_last_name, ''),
      v_email,
      v_phone,
      NEW.raw_user_meta_data->>'company',
      CASE WHEN NEW.raw_user_meta_data->'address' IS NOT NULL
           THEN NEW.raw_user_meta_data->'address'
           ELSE NULL
      END,
      NEW.raw_user_meta_data->>'acquisition_source',
      NEW.raw_user_meta_data->>'notes',
      CASE WHEN (NEW.raw_user_meta_data->>'gdpr_consent_date') IS NOT NULL
           THEN (NEW.raw_user_meta_data->>'gdpr_consent_date')::timestamptz
           ELSE NULL
      END,
      jsonb_build_object(
        'email', coalesce((NEW.raw_user_meta_data->>'consent_marketing')::boolean, false),
        'sms',   false,
        'phone', false
      )
    );

    RETURN NEW;
  END IF;

  -- ── Fallback: no slug, no photographer role → do nothing ──
  RETURN NEW;
END;
$$;
