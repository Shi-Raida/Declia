-- Multi-step registration: add business columns to tenants, replace signup trigger.

-- 1. Add business columns to tenants
ALTER TABLE public.tenants
  ADD COLUMN IF NOT EXISTS company_name TEXT,
  ADD COLUMN IF NOT EXISTS siret        TEXT,
  ADD COLUMN IF NOT EXISTS legal_form   TEXT,
  ADD COLUMN IF NOT EXISTS vat_number   TEXT,
  ADD COLUMN IF NOT EXISTS address      JSONB;

-- 2. Replace handle_new_user() to support client + photographer self-signup.
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
      address, acquisition_source, notes, gdpr_consent_date,
      communication_prefs
    ) VALUES (
      v_tenant_id,
      NEW.id,
      coalesce(v_first_name, ''),
      coalesce(v_last_name, ''),
      v_email,
      v_phone,
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
