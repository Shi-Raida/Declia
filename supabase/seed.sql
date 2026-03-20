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
   '{"provider":"email","providers":["email"]}','{}', now(), now()),
  ('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0001-000000000004','authenticated','authenticated',
   'tech@fleur.test', crypt('password123',gen_salt('bf')), now(),
   '','','','',
   '{"provider":"email","providers":["email"]}','{}', now(), now())
ON CONFLICT (id) DO NOTHING;

-- public.users: bind auth users to tenants
INSERT INTO public.users (id, tenant_id, role) VALUES
  ('00000000-0000-0000-0001-000000000001','00000000-0000-0000-0000-000000000001','photographer'),
  ('00000000-0000-0000-0001-000000000002','00000000-0000-0000-0000-000000000001','client'),
  ('00000000-0000-0000-0001-000000000003','00000000-0000-0000-0000-000000000002','photographer'),
  ('00000000-0000-0000-0001-000000000004','00000000-0000-0000-0000-000000000001','tech')
ON CONFLICT (id) DO NOTHING;

-- =============================================================
-- M2 SEED DATA
-- =============================================================

-- -------------------------------------------------------------
-- Clients (M2-S1/S2)
-- IDs: 10000000-0000-0000-0000-00000000000X
-- -------------------------------------------------------------

-- Tenant A: Fleur de Lumiere (6 clients)
INSERT INTO public.clients (
  id, tenant_id,
  first_name, last_name, email, phone, date_of_birth,
  address, acquisition_source, tags, notes,
  communication_prefs, gdpr_consent_date
) VALUES
  (
    '10000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000001',
    'Sophie', 'Moreau', 'sophie.moreau@email.fr', '+33 6 12 34 56 78',
    '1988-04-15',
    '{"street":"12 rue des Lilas","city":"Paris","postal_code":"75011","country":"FR"}',
    'referral',
    ARRAY['portrait','wedding'],
    'Cliente fidèle depuis 2023. Préfère les séances en extérieur le matin.',
    '{"email":true,"sms":true,"phone":false}',
    NOW() - INTERVAL '18 months'
  ),
  (
    '10000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000001',
    'Thomas', 'Dubois', 'thomas.dubois@gmail.com', '+33 6 98 76 54 32',
    '1982-11-03',
    '{"street":"5 avenue Victor Hugo","city":"Lyon","postal_code":"69002","country":"FR"}',
    'word_of_mouth',
    ARRAY['family'],
    NULL,
    '{"email":true,"sms":false,"phone":true}',
    NOW() - INTERVAL '12 months'
  ),
  (
    '10000000-0000-0000-0000-000000000003',
    '00000000-0000-0000-0000-000000000001',
    'Marie', 'Lefebvre', 'marie.lefebvre@outlook.com', NULL,
    '1993-07-22',
    NULL,
    'social_media',
    ARRAY['maternity','family'],
    'Contactée via Instagram. Enceinte de 7 mois lors du premier contact.',
    '{"email":true,"sms":false,"phone":false}',
    NOW() - INTERVAL '3 months'
  ),
  (
    '10000000-0000-0000-0000-000000000004',
    '00000000-0000-0000-0000-000000000001',
    'Laurent', 'Bernard', 'l.bernard@entreprise.fr', '+33 7 11 22 33 44',
    NULL,
    '{"street":"28 boulevard Haussmann","city":"Paris","postal_code":"75009","country":"FR"}',
    'website',
    ARRAY['portrait','event'],
    NULL,
    '{"email":true,"sms":true,"phone":true}',
    NULL
  ),
  (
    '10000000-0000-0000-0000-000000000005',
    '00000000-0000-0000-0000-000000000001',
    'Camille', 'Rousseau', 'camille.rousseau@mail.fr', '+33 6 55 44 33 22',
    '1990-02-08',
    NULL,
    'referral',
    ARRAY['equestrian','portrait'],
    'Cavalière professionnelle. Souhaite des photos avec ses chevaux au haras de Chantilly.',
    '{"email":false,"sms":true,"phone":true}',
    NOW() - INTERVAL '6 months'
  ),
  (
    '10000000-0000-0000-0000-000000000006',
    '00000000-0000-0000-0000-000000000001',
    'Julien', 'Petit', 'julien.petit@hotmail.fr', NULL,
    NULL,
    NULL,
    'event',
    ARRAY['portrait'],
    NULL,
    '{"email":true,"sms":false,"phone":false}',
    NULL
  ),

-- Tenant B: Studio Luminos (2 clients)
  (
    '10000000-0000-0000-0000-000000000007',
    '00000000-0000-0000-0000-000000000002',
    'Ana', 'Popescu', 'ana.popescu@email.ro', '+40 72 123 4567',
    '1991-09-14',
    NULL,
    'referral',
    ARRAY['portrait'],
    NULL,
    '{"email":true,"sms":false,"phone":false}',
    NOW() - INTERVAL '8 months'
  ),
  (
    '10000000-0000-0000-0000-000000000008',
    '00000000-0000-0000-0000-000000000002',
    'Ion', 'Ionescu', 'ion.ionescu@gmail.com', '+40 74 987 6543',
    NULL,
    NULL,
    'social_media',
    ARRAY['family'],
    NULL,
    '{"email":true,"sms":true,"phone":false}',
    NULL
  )
ON CONFLICT (id) DO NOTHING;

-- -------------------------------------------------------------
-- Availability Rules (M2-S5)
-- IDs: 60000000-0000-0000-0000-00000000000X
-- -------------------------------------------------------------

-- Tenant A: Mon–Fri recurring + 1 override Saturday + 1 blocked day
INSERT INTO public.availability_rules (id, tenant_id, rule_type, day_of_week, specific_date, start_time, end_time, label) VALUES
  ('60000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000001','recurring',1,NULL,'09:00','18:00','Lundi'),
  ('60000000-0000-0000-0000-000000000002','00000000-0000-0000-0000-000000000001','recurring',2,NULL,'09:00','18:00','Mardi'),
  ('60000000-0000-0000-0000-000000000003','00000000-0000-0000-0000-000000000001','recurring',3,NULL,'09:00','18:00','Mercredi'),
  ('60000000-0000-0000-0000-000000000004','00000000-0000-0000-0000-000000000001','recurring',4,NULL,'09:00','18:00','Jeudi'),
  ('60000000-0000-0000-0000-000000000005','00000000-0000-0000-0000-000000000001','recurring',5,NULL,'09:00','18:00','Vendredi'),
  ('60000000-0000-0000-0000-000000000006','00000000-0000-0000-0000-000000000001','override',NULL,
    (NOW() + INTERVAL '3 weeks')::DATE,
    '10:00','16:00','Samedi exceptionnel'),
  ('60000000-0000-0000-0000-000000000007','00000000-0000-0000-0000-000000000001','blocked',NULL,
    (NOW() + INTERVAL '5 weeks')::DATE,
    NULL,NULL,'Jour férié')
ON CONFLICT (id) DO NOTHING;

-- Tenant B: 1 recurring rule
INSERT INTO public.availability_rules (id, tenant_id, rule_type, day_of_week, specific_date, start_time, end_time, label) VALUES
  ('60000000-0000-0000-0000-000000000008','00000000-0000-0000-0000-000000000002','recurring',6,NULL,'10:00','17:00','Samedi')
ON CONFLICT (id) DO NOTHING;

-- -------------------------------------------------------------
-- Sessions (M2-S3/S4)
-- IDs: 20000000-0000-0000-0000-00000000000X
-- -------------------------------------------------------------

-- Tenant A: 8 sessions (past = completed/cancelled, future = scheduled/confirmed)
INSERT INTO public.sessions (id, tenant_id, client_id, type, status, scheduled_at, location, payment_status, amount, notes, duration_minutes) VALUES
  -- Completed (past)
  (
    '20000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000001',
    'portrait','completed',
    NOW() - INTERVAL '3 months',
    'Bois de Vincennes, Paris',
    'paid', 350.00,
    'Séance portrait en extérieur, lumière dorée de fin de journée.',
    60
  ),
  (
    '20000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000002',
    'family','completed',
    NOW() - INTERVAL '2 months',
    'Parc de la Tête d''Or, Lyon',
    'paid', 480.00,
    NULL,
    90
  ),
  (
    '20000000-0000-0000-0000-000000000003',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000003',
    'maternity','completed',
    NOW() - INTERVAL '6 weeks',
    'Studio Fleur de Lumiere',
    'partial', 280.00,
    'Séance maternité en studio. Reste 80€ à régler.',
    30
  ),
  (
    '20000000-0000-0000-0000-000000000004',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000004',
    'portrait','cancelled',
    NOW() - INTERVAL '5 weeks',
    NULL,
    'pending', 0.00,
    'Annulé par le client (urgence professionnelle).',
    60
  ),
  -- Future sessions
  (
    '20000000-0000-0000-0000-000000000005',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000005',
    'equestrian','confirmed',
    NOW() + INTERVAL '2 weeks',
    'Haras de Chantilly',
    'pending', 600.00,
    'Séance équestre. Prévoir tenue professionnelle et tenue décontractée.',
    120
  ),
  (
    '20000000-0000-0000-0000-000000000006',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000001',
    'portrait','scheduled',
    NOW() + INTERVAL '1 month',
    'Montmartre, Paris',
    'pending', 320.00,
    NULL,
    60
  ),
  (
    '20000000-0000-0000-0000-000000000007',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000002',
    'family','confirmed',
    NOW() + INTERVAL '3 weeks',
    'Domicile client',
    'partial', 450.00,
    'Acompte de 200€ reçu.',
    90
  ),
  (
    '20000000-0000-0000-0000-000000000008',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000006',
    'portrait','scheduled',
    NOW() + INTERVAL '6 weeks',
    NULL,
    'pending', 300.00,
    NULL,
    60
  )
ON CONFLICT (id) DO NOTHING;

-- Tenant B: 2 sessions
INSERT INTO public.sessions (id, tenant_id, client_id, type, status, scheduled_at, location, payment_status, amount, notes, duration_minutes) VALUES
  (
    '20000000-0000-0000-0000-000000000009',
    '00000000-0000-0000-0000-000000000002',
    '10000000-0000-0000-0000-000000000007',
    'portrait','completed',
    NOW() - INTERVAL '1 month',
    'Studio Luminos, Bucarest',
    'paid', 250.00,
    NULL,
    60
  ),
  (
    '20000000-0000-0000-0000-000000000010',
    '00000000-0000-0000-0000-000000000002',
    '10000000-0000-0000-0000-000000000008',
    'family','scheduled',
    NOW() + INTERVAL '2 weeks',
    NULL,
    'pending', 350.00,
    NULL,
    60
  )
ON CONFLICT (id) DO NOTHING;

-- -------------------------------------------------------------
-- Galleries (M2-S3)
-- IDs: 30000000-0000-0000-0000-00000000000X
-- -------------------------------------------------------------

INSERT INTO public.galleries (id, tenant_id, client_id, session_id, title, status, url_slug, photo_count) VALUES
  (
    '30000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000001',
    '20000000-0000-0000-0000-000000000001',
    'Portraits Sophie – Automne 2025',
    'published',
    'sophie-portraits-automne-2025',
    42
  ),
  (
    '30000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000002',
    '20000000-0000-0000-0000-000000000002',
    'Famille Dubois – Parc Tête d''Or',
    'published',
    'famille-dubois-parc',
    67
  ),
  (
    '30000000-0000-0000-0000-000000000003',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000003',
    '20000000-0000-0000-0000-000000000003',
    'Maternité Marie',
    'draft',
    NULL,
    28
  ),
  (
    '30000000-0000-0000-0000-000000000004',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000001',
    NULL,
    'Archives Sophie 2024',
    'archived',
    NULL,
    18
  ),
  (
    '30000000-0000-0000-0000-000000000005',
    '00000000-0000-0000-0000-000000000002',
    '10000000-0000-0000-0000-000000000007',
    '20000000-0000-0000-0000-000000000009',
    'Ana Popescu – Portraits',
    'published',
    'ana-popescu-portraits',
    35
  )
ON CONFLICT (id) DO NOTHING;

-- -------------------------------------------------------------
-- Orders (M2-S3)
-- IDs: 40000000-0000-0000-0000-00000000000X
-- -------------------------------------------------------------

INSERT INTO public.orders (id, tenant_id, client_id, session_id, status, total_amount, order_date, description) VALUES
  (
    '40000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000001',
    '20000000-0000-0000-0000-000000000001',
    'delivered', 350.00,
    NOW() - INTERVAL '10 weeks',
    'Forfait portrait – 42 photos HD + 10 tirages 20x30'
  ),
  (
    '40000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000001',
    '20000000-0000-0000-0000-000000000001',
    'shipped', 85.00,
    NOW() - INTERVAL '8 weeks',
    'Tirages supplémentaires 30x45 (x5)'
  ),
  (
    '40000000-0000-0000-0000-000000000003',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000002',
    '20000000-0000-0000-0000-000000000002',
    'delivered', 480.00,
    NOW() - INTERVAL '7 weeks',
    'Forfait famille – 67 photos HD + album 30x30'
  ),
  (
    '40000000-0000-0000-0000-000000000004',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000003',
    '20000000-0000-0000-0000-000000000003',
    'processing', 200.00,
    NOW() - INTERVAL '4 weeks',
    'Acompte séance maternité'
  ),
  (
    '40000000-0000-0000-0000-000000000005',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000004',
    '20000000-0000-0000-0000-000000000004',
    'cancelled', 0.00,
    NOW() - INTERVAL '5 weeks',
    'Séance annulée – aucun frais'
  ),
  (
    '40000000-0000-0000-0000-000000000006',
    '00000000-0000-0000-0000-000000000002',
    '10000000-0000-0000-0000-000000000007',
    '20000000-0000-0000-0000-000000000009',
    'delivered', 250.00,
    NOW() - INTERVAL '3 weeks',
    'Forfait portrait – 35 photos HD'
  )
ON CONFLICT (id) DO NOTHING;

-- -------------------------------------------------------------
-- Communication Logs (M2-S3)
-- IDs: 50000000-0000-0000-0000-00000000000X
-- -------------------------------------------------------------

INSERT INTO public.communication_logs (id, tenant_id, client_id, channel, subject, status, sent_at) VALUES
  (
    '50000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000001',
    'email',
    'Confirmation de votre séance portrait',
    'delivered',
    NOW() - INTERVAL '3 months' - INTERVAL '1 day'
  ),
  (
    '50000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000001',
    'email',
    'Votre galerie photo est disponible !',
    'delivered',
    NOW() - INTERVAL '10 weeks'
  ),
  (
    '50000000-0000-0000-0000-000000000003',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000002',
    'sms',
    NULL,
    'delivered',
    NOW() - INTERVAL '2 months' - INTERVAL '1 day'
  ),
  (
    '50000000-0000-0000-0000-000000000004',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000003',
    'email',
    'Facture séance maternité – Fleur de Lumiere',
    'sent',
    NOW() - INTERVAL '4 weeks'
  ),
  (
    '50000000-0000-0000-0000-000000000005',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000005',
    'email',
    'Confirmation séance équestre – Haras de Chantilly',
    'queued',
    NULL
  )
ON CONFLICT (id) DO NOTHING;

-- -------------------------------------------------------------
-- External Calendar Events (M2-S6)
-- IDs: 70000000-0000-0000-0000-00000000000X
-- Tenant A only (no real OAuth tokens needed)
-- -------------------------------------------------------------

INSERT INTO public.external_calendar_events (id, tenant_id, google_event_id, title, location, start_at, end_at, is_all_day, status) VALUES
  (
    '70000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000001',
    'google_ext_evt_001',
    'Rendez-vous dentiste',
    'Cabinet Dr. Martin, 15 rue de la Paix, Paris',
    (NOW()::DATE + INTERVAL '10 days' + INTERVAL '14 hours'),
    (NOW()::DATE + INTERVAL '10 days' + INTERVAL '15 hours'),
    false,
    'confirmed'
  ),
  (
    '70000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000001',
    'google_ext_evt_002',
    'Réunion famille',
    NULL,
    (NOW()::DATE + INTERVAL '4 weeks'),
    (NOW()::DATE + INTERVAL '4 weeks' + INTERVAL '1 day'),
    true,
    'confirmed'
  ),
  (
    '70000000-0000-0000-0000-000000000003',
    '00000000-0000-0000-0000-000000000001',
    'google_ext_evt_003',
    'Formation Lightroom avancé',
    'Centre de formation, Lyon',
    (NOW()::DATE + INTERVAL '5 days' + INTERVAL '9 hours'),
    (NOW()::DATE + INTERVAL '5 days' + INTERVAL '17 hours'),
    false,
    'confirmed'
  ),
  (
    '70000000-0000-0000-0000-000000000004',
    '00000000-0000-0000-0000-000000000001',
    'google_ext_evt_004',
    'Entretien voiture',
    'Garage Saint-Michel',
    (NOW()::DATE + INTERVAL '8 days' + INTERVAL '10 hours 30 minutes'),
    (NOW()::DATE + INTERVAL '8 days' + INTERVAL '12 hours'),
    false,
    'tentative'
  )
ON CONFLICT (tenant_id, google_event_id) DO NOTHING;

-- -------------------------------------------------------------
-- Session Google Sync (M2-S6)
-- Links Declia sessions to fake Google Calendar event IDs
-- -------------------------------------------------------------

INSERT INTO public.session_google_sync (session_id, tenant_id, google_event_id, last_synced_at) VALUES
  (
    '20000000-0000-0000-0000-000000000005',
    '00000000-0000-0000-0000-000000000001',
    'google_session_evt_005',
    NOW() - INTERVAL '1 day'
  ),
  (
    '20000000-0000-0000-0000-000000000007',
    '00000000-0000-0000-0000-000000000001',
    'google_session_evt_007',
    NOW() - INTERVAL '2 hours'
  )
ON CONFLICT (session_id) DO NOTHING;
