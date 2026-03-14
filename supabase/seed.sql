-- Tenant A: Fleur de Lumiere (the primary test tenant)
INSERT INTO public.tenants (id, name, slug, branding, domain) VALUES
  ('00000000-0000-0000-0000-000000000001','Fleur de Lumiere','fleur-de-lumiere','{"primary_color":"#C084A0","logo_url":null}','fleur-de-lumiere.local'),
  ('00000000-0000-0000-0000-000000000002','Studio Luminos','studio-luminos','{}',null)
ON CONFLICT (id) DO NOTHING;

-- auth.users (supabase local only; service_role bypasses auth API)
-- Token columns must be '' (not NULL) or GoTrue throws a scan error on login.
INSERT INTO auth.users (
  instance_id, id, aud, role,
  email, encrypted_password, email_confirmed_at,
  confirmation_token, recovery_token, email_change_token_new, email_change,
  raw_app_meta_data, raw_user_meta_data,
  created_at, updated_at
) VALUES
  ('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0001-000000000001','authenticated','authenticated',
   'photo@fleur.test',  crypt('password123',gen_salt('bf')), now(),
   '','','','',
   '{"provider":"email","providers":["email"]}','{}', now(), now()),
  ('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0001-000000000002','authenticated','authenticated',
   'client@fleur.test', crypt('password123',gen_salt('bf')), now(),
   '','','','',
   '{"provider":"email","providers":["email"]}','{}', now(), now()),
  ('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0001-000000000003','authenticated','authenticated',
   'photo@luminos.test',crypt('password123',gen_salt('bf')), now(),
   '','','','',
   '{"provider":"email","providers":["email"]}','{}', now(), now())
ON CONFLICT (id) DO NOTHING;

-- public.users: bind auth users to tenants
INSERT INTO public.users (id, tenant_id, role) VALUES
  ('00000000-0000-0000-0001-000000000001','00000000-0000-0000-0000-000000000001','photographer'),
  ('00000000-0000-0000-0001-000000000002','00000000-0000-0000-0000-000000000001','client'),
  ('00000000-0000-0000-0001-000000000003','00000000-0000-0000-0000-000000000002','photographer')
ON CONFLICT (id) DO NOTHING;
