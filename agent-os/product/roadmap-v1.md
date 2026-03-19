# Declia V1 -- Milestone Breakdown

## Conventions

- **Roles:** Photographer (admin/back-office), Client (end-user), Visitor (anonymous public), Guest (shared gallery access), Developer (tech)
- **Traceability:** CDC.2 (March 2026, definitive version) section numbers
- **Story format:** "As a [role], I want [action] so that [benefit]"
- **Status values:** `Done` | `In progress` | `Not started` | `Blocked`
- **Architecture:** Clean Architecture as defined in `.raida-arch.json`:
  - `lib/domain/`, `lib/core/` -- Entities, value objects, shared core (no dependencies)
  - `lib/usecases/` -- Application business rules (depends on entities)
  - `lib/presentation/` -- UI pages, widgets, theme, controllers (depends on usecases, entities)
  - `lib/infrastructure/` -- Data sources, repository implementations, external services (depends on all)
  - Rules: max 300 lines/file, max 10 methods/class, no circular dependencies

## Visual References

Harmonized HTML mockups are available in `docs/visuals/harmonized/` organized by module. The visual hub index is at `docs/visuals/index.html`. Below, each milestone references its applicable mockups.

| Module | Directory | V1 Mockups |
|--------|-----------|------------|
| Site Public | `harmonized/site-public/` | 01-accueil, 02-apropos, 03-portfolio-temoignages, 04-specialite-equestre, 05-tarifs, 06-boutique, 07-cartes-cadeau-faq, 08-offres-legal, 09-contact |
| Booking | `harmonized/booking/` | 01-reservation-part1, 02-reservation-part2 |
| Espace Client | `harmonized/espace-client/` | 01-client-journey, 03-notifications, 04-coffret-numerique, 07-before-after, 10-espace-client |
| Admin | `harmonized/admin/` | 01-dashboard, 02-facturation, 07-scolaire-admin, 08-scolaire-ecole-parent, 09-marketing-automation, 10-export-comptable, 11-mini-sessions, 12-session-recap, 13-education-hub, 14-referral-proof, 19-statistiques |

Design system: `docs/visuals/harmonized/design-system.css`

## Milestone Overview

| # | Milestone | Description | Deps |
|---|-----------|-------------|------|
| M1 | Foundations & Admin Shell | Flutter init, Supabase, multi-role auth, multi-tenant, admin shell | - |
| M2 | CRM & Planning | Client profiles, calendar, availability, Google Calendar sync | M1 |
| M3 | Public Showcase | Public pages, portfolio, pricing, SEO, contact, responsive | M1 |
| M4 | Booking System | Formula booking, event quotes, Stripe, questionnaire, reminders | M1-M3 |
| M5 | Delivery Galleries | Upload, galleries, sub-folders, favorites, download, sharing, expiration | M1-M2 |
| M6 | Client Space & Premium Experience | Client account, Client Journey, Coffret Numerique, Before/After, Selection | M1-M5 |
| M7 | Integrated Shop | Product catalog, contextual purchase, cart, payment, order management | M1-M2, M5-M6 |
| M8 | Gift Cards, Loyalty & Promotions | Gift cards, referral, points, 4 Seasons subscription, promo offers | M1-M4, M7 |
| M9 | Mini-Sessions & School Module | Automated mini-session events, Parent Gallery for school photography | M1-M5, M7 |
| M10 | Workflow & Task Automation | Multi-view tasks, templates, auto-creation, Client Journey link | M1-M2, M4, M6 |
| M11 | Emails, SMS & Education Hub | Email/SMS templates, dynamic variables, 9 pre-shooting guides | M1-M2, M4-M5, M10 |
| M12 | Marketing Automation V1 | 6 campaigns, Session Recap, Referral Proof, campaign dashboard | M1-M2, M5, M7-M8, M10-M11 |
| M13 | Invoicing & Accounting Export | Factur-X, quotes, invoices, URSSAF, exports, financial dashboard | M1-M2, M4, M7 |
| M14 | Statistics, Notifications & Referral Proof | KPI dashboard, push notifications, social proof on showcase | M1-M2, M4-M5, M7-M8, M12-M13 |
| M15 | Security, GDPR & Launch | Security, compliance, final SEO, messaging center, admin content, performance | M1-M14 |

## Dependency Graph

```
M1 ──┬──> M2 ──┬──> M4 ──┐
     │         │         │
     ├──> M3 ──┘         ├──> M8 ──┐
     │                   │         │
     └──────── M5 ──> M6 ┤         ├──> M12 ──┐
                         │         │           │
                    M7 ──┘    M9 ──┘      M13 ─┤──> M14 ──> M15
                         │                     │
                    M10 ──> M11 ───────────────┘
```

Parallelizable: M9, M10, M13 can be developed in parallel after M8.

## Progress Tracking

| Step | Description | Status |
|------|-------------|--------|
| **M1** | **Foundations & Admin Shell** | **Done** |
| M1-S1 | Flutter project initialization | Done |
| M1-S2 | Supabase setup & database | Done |
| M1-S3 | Multi-tenant architecture | Done |
| M1-S4 | Photographer authentication | Done |
| M1-S5 | Client authentication | Done |
| M1-S6 | Admin shell & navigation | Done |
| M1-S7 | Role management & access control | Done |
| M1-S8 | Base security & GDPR foundations | Done |
| **M2** | **CRM & Planning** | **In progress** |
| M2-S1 | Client CRM profiles | Done |
| M2-S2 | Client list & filtering | Done |
| M2-S3 | Client history | Done |
| M2-S4 | Calendar & planning view | Done |
| M2-S5 | Availability management | Done |
| M2-S6 | Google Calendar sync | Done |
| **M3** | **Public Showcase** | **Not started** |
| M3-S1 | Home page with seasonal mode | Not started |
| M3-S2 | Portfolio by specialty | Not started |
| M3-S3 | Pricing & formulas page | Not started |
| M3-S4 | About page | Not started |
| M3-S5 | Testimonials page & Google Reviews | Not started |
| M3-S6 | FAQ & Contact pages | Not started |
| M3-S7 | Legal pages & social links | Not started |
| M3-S8 | SEO & performance foundations | Not started |
| **M4** | **Booking System** | **Not started** |
| M4-S1 | Standard formula booking | Not started |
| M4-S2 | Event booking via quote | Not started |
| M4-S3 | Pre-shooting questionnaire | Not started |
| M4-S4 | Booking automations | Not started |
| M4-S5 | Stripe integration & payment | Not started |
| **M5** | **Delivery Galleries** | **Not started** |
| M5-S1 | Upload & gallery creation (admin) | Not started |
| M5-S2 | Client gallery access | Not started |
| M5-S3 | Gallery features (favorites, comments, download) | Not started |
| M5-S4 | Gallery sharing with guests | Not started |
| M5-S5 | Expiration & gallery management | Not started |
| **M6** | **Client Space & Premium Experience** | **Not started** |
| M6-S1 | Complete client space | Not started |
| M6-S2 | Visual Client Journey | Not started |
| M6-S3 | Coffret Numerique -- premium delivery | Not started |
| M6-S4 | Before/After retouching | Not started |
| M6-S5 | Selection galleries | Not started |
| **M7** | **Integrated Shop** | **Not started** |
| M7-S1 | Product catalog (admin) | Not started |
| M7-S2 | Contextual purchase from gallery | Not started |
| M7-S3 | Cart & shop payment | Not started |
| M7-S4 | Order management (admin) | Not started |
| **M8** | **Gift Cards, Loyalty & Promotions** | **Not started** |
| M8-S1 | Gift cards | Not started |
| M8-S2 | Gift card management center (admin) | Not started |
| M8-S3 | Loyalty program | Not started |
| M8-S4 | Referral system | Not started |
| M8-S5 | 4 Seasons subscription | Not started |
| M8-S6 | Promotional offers system | Not started |
| **M9** | **Mini-Sessions & School Module** | **Not started** |
| M9-S1 | Mini-session event creation (admin) | Not started |
| M9-S2 | Mini-session public page | Not started |
| M9-S3 | Mini-session booking & payment | Not started |
| M9-S4 | Mini-session waitlist | Not started |
| M9-S5 | Mini-session dashboard (admin) | Not started |
| M9-S6 | School gallery creation (admin) | Not started |
| M9-S7 | Parent journey -- school gallery | Not started |
| M9-S8 | School order management | Not started |
| **M10** | **Workflow & Task Automation** | **Not started** |
| M10-S1 | Task management views | Not started |
| M10-S2 | Detailed task management | Not started |
| M10-S3 | Workflow templates per session type | Not started |
| M10-S4 | Automatic task creation on booking | Not started |
| M10-S5 | Workflow-Client Journey connection | Not started |
| **M11** | **Emails, SMS & Education Hub** | **Not started** |
| M11-S1 | Email template system | Not started |
| M11-S2 | Booking-related emails | Not started |
| M11-S3 | Gallery-related emails | Not started |
| M11-S4 | Post-shooting emails | Not started |
| M11-S5 | Automated SMS | Not started |
| M11-S6 | Education Hub -- preparation guides | Not started |
| **M12** | **Marketing Automation V1** | **Not started** |
| M12-S1 | Avant-Premiere campaign | Not started |
| M12-S2 | Abandoned Cart campaign | Not started |
| M12-S3 | Last Chance campaign | Not started |
| M12-S4 | Gallery Wake-up campaign | Not started |
| M12-S5 | Session Recap (mobile form) | Not started |
| M12-S6 | Referral Proof -- social proof | Not started |
| M12-S7 | Marketing campaign dashboard | Not started |
| **M13** | **Invoicing & Accounting Export** | **Not started** |
| M13-S1 | Automatic quote generation | Not started |
| M13-S2 | Automatic invoice generation | Not started |
| M13-S3 | Payment tracking | Not started |
| M13-S4 | Financial dashboard | Not started |
| M13-S5 | Accounting exports | Not started |
| **M14** | **Statistics, Notifications & Referral Proof** | **Not started** |
| M14-S1 | Global KPI dashboard | Not started |
| M14-S2 | Multi-platform push notifications | Not started |
| M14-S3 | Notification preferences | Not started |
| M14-S4 | Referral Proof showcase integration | Not started |
| **M15** | **Security, GDPR & Launch** | **Not started** |
| M15-S1 | Infrastructure security | Not started |
| M15-S2 | GDPR compliance | Not started |
| M15-S3 | SEO finalization | Not started |
| M15-S4 | Messaging center | Not started |
| M15-S5 | Showcase content management (admin) | Not started |
| M15-S6 | Performance optimization & launch | Not started |

---

## M1: Foundations & Admin Shell

**Description:** Flutter project init, Supabase setup, multi-role auth (photographer + client), multi-tenant architecture, and base admin shell.

**Dependencies:** None (first milestone)

**CDC Ref:** 1.3, 1.5, 15.11, 23.1, 23.2, 23.4

**Mockups:** `admin/01-dashboard.html` (admin shell layout), `design-system.css` (theme/branding reference)

---

### M1-S1: Flutter project initialization -- `Done`

**As a** developer, **I want** to initialize the Flutter project with folder structure, code conventions and linting **so that** we have a clean, standardized codebase for all future development.

**Acceptance criteria:**
- [ ] Flutter project compiles and launches without errors on web, iOS and Android
- [ ] Folder structure follows Clean Architecture as defined in `.raida-arch.json`: `lib/{domain,core,usecases,presentation,infrastructure}`
- [ ] `analysis_options.yaml` configured with flutter_lints and defined rules
- [ ] Routing in place with a placeholder home page
- [ ] Base theme respects Rose Sauvage branding: plum (#4A2E3D), rose (#C2727E), charcoal (#2D2226), white/cream background, Cormorant Garamond (titles) and Outfit (body) fonts

---

### M1-S2: Supabase setup & database -- `Done`

**As a** developer, **I want** to configure the Supabase project with PostgreSQL, storage and Edge Functions **so that** we have the complete backend infrastructure.

**Acceptance criteria:**
- [ ] Supabase project created and connected to Flutter via Supabase Dart client
- [ ] Core tables created via migrations: `tenants`, `profiles`, `users` with Row Level Security (RLS) enabled
- [ ] Supabase Storage configured with separate buckets (avatars, gallery-photos, documents) and RLS policies
- [ ] A test Edge Function responds correctly from the Flutter client
- [ ] Environment variables (Supabase URL, anon key) managed via config file, not hardcoded

---

### M1-S3: Multi-tenant architecture -- `Done`

**As a** developer, **I want** to set up a multi-tenant architecture isolated by tenant_id **so that** each photographer's data is completely separated.

**Acceptance criteria:**
- [ ] `tenants` table with fields: id, name, slug, branding (JSON), domain, created_at
- [ ] All business tables have a `tenant_id` column with foreign key to tenants
- [ ] RLS policies automatically filter data by the connected user's tenant_id
- [ ] A test tenant (Fleur de Lumiere) is seeded and usable
- [ ] It is impossible for a user from one tenant to access another tenant's data (verified by test)

---

### M1-S4: Photographer authentication -- `Done`

**As a** photographer, **I want** to log in to the back-office with email and password **so that** I can access my secure admin space.

**Acceptance criteria:**
- [ ] Admin login screen functional with email + password via Supabase Auth
- [ ] After login, photographer is redirected to the admin dashboard
- [ ] A `photographer` role is assigned in user metadata and verified via RLS
- [ ] Logout works and redirects to login page
- [ ] Passwords managed by Supabase Auth (bcrypt hashed)

---

### M1-S5: Client authentication

**As a** client, **I want** to create an account and log in with email and password **so that** I can access my personal space.

**Acceptance criteria:**
- [ ] Client registration via email + password with email verification
- [ ] Client login redirects to a client space (empty shell for now)
- [ ] A `client` role is assigned in user metadata, distinct from `photographer`
- [ ] Client cannot access admin routes (automatic redirect)
- [ ] Password reset via email works

---

### M1-S6: Admin shell & navigation

**As a** photographer, **I want** an admin layout with sidebar navigation, header and content area **so that** I can navigate between back-office sections.

**Acceptance criteria:**
- [ ] Admin layout includes: sidebar (collapsible on mobile), header with photographer name and logout button, main content area
- [ ] Sidebar shows navigation entries: Dashboard, Clients, Planning, Galleries, Shop, Invoicing, Statistics, Settings
- [ ] Design respects the branding theme (dark/premium)
- [ ] Responsive: sidebar drawer on mobile, fixed sidebar on desktop/tablet
- [ ] Dashboard page shows a welcome message (real content in later milestones)

---

### M1-S7: Role management & access control -- `Done`

**As a** developer, **I want** to implement a role system (photographer full admin, developer tech access, future assistant) **so that** permissions are properly controlled -- CDC 15.11.

**Acceptance criteria:**
- [x] Three roles defined: `photographer` (full admin), `tech` (tech + admin access), `client` (client space only)
- [x] A route guard (middleware) verifies the role before accessing each protected route
- [x] Supabase RLS policies are consistent with Flutter roles (double client + server verification)
- [x] Unauthorized route access attempt: redirect with message

---

### M1-S8: Base security & GDPR foundations

**As a** developer, **I want** to set up security and GDPR compliance foundations **so that** the platform is secure and compliant from day one -- CDC 23.1, 23.2.

**Acceptance criteria:**
- [ ] HTTPS enforced on the entire site
- [ ] Anti-brute-force protections active on authentication (Supabase Auth rate limiting)
- [ ] `consent_records` table exists to record consents with timestamps
- [ ] A compliant cookie banner displayed on first access (accept/refuse/customize)
- [ ] Privacy policy and legal notices have defined routes (content in M3)

---

## M2: CRM & Planning

**Description:** Complete client profiles with history, availability calendar and Google Calendar sync.

**Dependencies:** M1

**CDC Ref:** 15.1, 15.2

---

### M2-S1: Client CRM profiles

**As a** photographer, **I want** to create and manage complete client profiles **so that** I can centralize client knowledge and personalize my relationship -- CDC 15.1.

**Acceptance criteria:**
- [ ] Client profile: first name, last name, email, phone, address, date of birth
- [ ] Additional fields: acquisition source, tags/categories, personal notes, preferences
- [ ] GDPR consent recorded with date and communication preferences
- [ ] Full CRUD from admin
- [ ] Client search by name, email or phone with instant results

---

### M2-S2: Client list & filtering

**As a** photographer, **I want** to see all my clients with filters and sorting **so that** I can quickly find a client or segment my base.

**Acceptance criteria:**
- [ ] List shows: full name, email, phone, number of sessions, total spent, last shooting
- [ ] Filters: by tag/category, acquisition source, last session date
- [ ] Sort: by name, creation date, total spent, last activity
- [ ] Pagination for large lists
- [ ] Total client count displayed

---

### M2-S3: Client history

**As a** photographer, **I want** to view a client's complete history (shootings, galleries, orders, payments, communications) **so that** I have a 360-degree view -- CDC 15.1.

**Acceptance criteria:**
- [ ] Shooting history (past and upcoming) with date, location, status, payment state
- [ ] Associated galleries listed with direct link
- [ ] Order history (prints, objects) with status
- [ ] Lifetime total spent calculated and displayed
- [ ] Email/SMS sent history with status (data structure ready)

---

### M2-S4: Calendar & planning view

**As a** photographer, **I want** to visualize my schedule as a calendar (day/week/month) **so that** I can see planned sessions and availability at a glance -- CDC 15.2.

**Acceptance criteria:**
- [ ] Three views: day, week, month
- [ ] Sessions displayed with: client name, session type, time, location
- [ ] Color coding by session type (family, equestrian, event, maternity, school)
- [ ] Click on a slot opens session detail with link to client profile
- [ ] Smooth navigation between periods (prev/next/today)

---

### M2-S5: Availability management

**As a** photographer, **I want** to define my recurring and manual availability slots **so that** clients can only book on open slots -- CDC 15.2.

**Acceptance criteria:**
- [ ] Recurring slots (e.g., Wednesday 9am-6pm, Saturday 8am-12pm)
- [ ] Manual override slots for specific dates
- [ ] Block entire days (vacations, unavailability)
- [ ] Slots occupied by existing sessions automatically removed from availability
- [ ] Availability data serves as base for booking system (M4)

---

### M2-S6: Google Calendar sync

**As a** photographer, **I want** to sync my Declia calendar with Google Calendar bidirectionally **so that** I only need one calendar -- CDC 15.2.

**Acceptance criteria:**
- [x] OAuth2 connection with Google Calendar from admin settings
- [x] Declia sessions appear in Google Calendar with title, location and time
- [x] Google Calendar events block corresponding slots in Declia
- [x] Bidirectional near real-time sync (webhook or 5 min polling)
- [x] Disconnect possible without losing Declia data

---

## M3: Public Showcase

**Description:** All public pages with responsive mobile-first design and SEO foundations.

**Dependencies:** M1

**CDC Ref:** 2.1, 2.2, 23.3, 17

**Mockups:** `site-public/01-accueil.html`, `site-public/02-apropos.html`, `site-public/03-portfolio-temoignages.html`, `site-public/04-specialite-equestre.html`, `site-public/05-tarifs.html`, `site-public/08-offres-legal.html`, `site-public/09-contact.html`

---

### M3-S1: Home page with seasonal mode

**As a** visitor, **I want** an elegant home page with a seasonal hero visual **so that** I immediately understand the photographer's universe -- CDC 2.1.

**Acceptance criteria:**
- [ ] Full-screen hero image/slideshow configurable from admin
- [ ] Seasonal mode: visual changes automatically by period (spring/summer/autumn/winter) with manual override
- [ ] Specialties presented with links to dedicated pages
- [ ] Visible booking CTA
- [ ] Featured client testimonials (3-4 excerpts)
- [ ] Promotional banner toggleable from admin

---

### M3-S2: Portfolio by specialty

**As a** visitor, **I want** to explore a portfolio organized by specialty **so that** I can judge the style and quality before booking -- CDC 2.1.

**Acceptance criteria:**
- [ ] Dedicated page per specialty: Family, Equestrian, Events, Maternity, School
- [ ] Content: approach description, public portfolio gallery, pricing/formulas, booking button
- [ ] High-quality photo display with smooth navigation (responsive grid, lightbox)
- [ ] Social sharing buttons on public galleries -- CDC 2.2
- [ ] Content editable from back-office

---

### M3-S3: Pricing & formulas page

**As a** visitor, **I want** to see pricing and available formulas with add-on options **so that** I can choose the right service -- CDC 2.1.

**Acceptance criteria:**
- [ ] 3 formulas displayed (Essential, Signature, Custom) with prices and details
- [ ] Add-on options visible (extra photos, extended duration)
- [ ] Events show "Quote only" with quote request button
- [ ] Maternity shows specific formulas (Premiere Lumiere, Nid Douillet)
- [ ] Direct booking button on each standard formula
- [ ] Pricing fully configurable from admin

---

### M3-S4: About page

**As a** visitor, **I want** to read the photographer's story **so that** I build emotional trust -- CDC 2.1.

**Acceptance criteria:**
- [ ] Presentation: story, philosophy, differentiator (Golden Hour, natural light)
- [ ] Illustrated with quality photos
- [ ] Consistent design with rest of site
- [ ] Content editable from admin

---

### M3-S5: Testimonials page & Google Reviews integration

**As a** visitor, **I want** to read authentic reviews **so that** I feel reassured about quality -- CDC 2.1.

**Acceptance criteria:**
- [ ] Google reviews imported via Google Places/Google My Business API
- [ ] Admin can select/moderate displayed reviews
- [ ] Each testimonial shows: name, star rating, text, date, Google badge
- [ ] Automated collection structure ready (trigger in M11+)
- [ ] Responsive grid/carousel

---

### M3-S6: FAQ & Contact pages

**As a** visitor, **I want** to find answers and contact the photographer easily -- CDC 2.1.

**Acceptance criteria:**
- [ ] FAQ: questions by theme, collapsible accordion sections, manageable from admin
- [ ] Contact: form (name, email, message), subject selector, address, intervention zone map
- [ ] Contact messages received in admin messaging center (photographer notified)
- [ ] Anti-spam protection (captcha or honeypot)

---

### M3-S7: Legal pages & social links

**As a** visitor, **I want** access to legal notices, T&C and privacy policy -- CDC 2.1, 2.2.

**Acceptance criteria:**
- [ ] Legal notices, T&C, privacy policy pages with editable content
- [ ] Social links (Instagram, Facebook, TikTok) in footer and/or header -- CDC 2.2
- [ ] Fully responsive design (mobile first) -- CDC 2.2
- [ ] SEO: meta tags, descriptions, automatic sitemap, clean URL structure -- CDC 23.3

---

### M3-S8: SEO & performance foundations

**As a** photographer, **I want** my site optimized for search engines **so that** potential clients find me -- CDC 23.3.

**Acceptance criteria:**
- [ ] Editable meta title and description per page from admin
- [ ] Open Graph tags for social sharing
- [ ] Automatically generated XML sitemap
- [ ] Clean, readable URL structure
- [ ] Optimized images (lazy loading, compression, WebP format)

---

## M4: Booking System

**Description:** Complete booking flow for standard sessions (formulas) and events (quotes), with Stripe payments and automations.

**Dependencies:** M1, M2, M3

**CDC Ref:** 3.1, 3.2, 3.3, 3.4

**Mockups:** `booking/01-reservation-part1.html`, `booking/02-reservation-part2.html`

---

### M4-S1: Standard formula booking (family/equestrian/portrait)

**As a** client, **I want** to book a photo session by choosing a formula, date and paying online **so that** my booking is guaranteed -- CDC 3.2.

**Acceptance criteria:**
- [ ] Client chooses formula (Essential/Signature/Custom) and options from pricing page
- [ ] Selects an available slot from calendar (based on M2 availability)
- [ ] Full payment via Stripe (card, Apple Pay, Google Pay) -- CDC 3.3
- [ ] After payment, booking created with "pending validation" status
- [ ] Photographer receives notification and validates booking
- [ ] Automatic confirmation email to client with recap -- CDC 3.4

---

### M4-S2: Event booking via quote

**As a** client, **I want** to request a quote for an event (wedding, christening) **so that** I receive a personalized offer -- CDC 3.2.

**Acceptance criteria:**
- [ ] Dedicated quote request form (date, event type, venue, guest count, specific needs)
- [ ] Photographer creates and sends quote from admin
- [ ] Client validates quote online and pays deposit (30%) via Stripe
- [ ] Balance due before delivery (automatic reminder)
- [ ] Gallery delivered once balance is paid

---

### M4-S3: Pre-shooting questionnaire

**As a** photographer, **I want** to send an automatic questionnaire after booking **so that** I can prepare the session -- CDC 3.4.

**Acceptance criteria:**
- [ ] Questionnaire adapted by session type (family: children count/ages; equestrian: horse name/stable; maternity: pregnancy month)
- [ ] Automatic sending after booking confirmation
- [ ] Client fills it online (responsive form)
- [ ] Responses saved and visible in CRM client profile
- [ ] Photographer notified when questionnaire is completed

---

### M4-S4: Booking automations

**As a** client, **I want** to receive a reminder before my shooting and be able to cancel/reschedule **so that** I don't forget and keep flexibility -- CDC 3.4.

**Acceptance criteria:**
- [ ] Automatic D-3 email reminder with practical recap (location, time, tips)
- [ ] Preparation guide (Education Hub) sent by session type -- structure ready, content in M11
- [ ] Online cancellation with configurable policy (delay, partial/full refund)
- [ ] Online rescheduling to another available slot
- [ ] Each action updates status and notifies photographer

---

### M4-S5: Stripe integration & payment management

**As a** developer, **I want** to integrate Stripe for all payments **so that** transactions are handled securely -- CDC 3.3.

**Acceptance criteria:**
- [ ] Stripe Checkout or Payment Intents integrated (card, Apple Pay, Google Pay)
- [ ] Deposit (30%) and balance management
- [ ] Recurring Stripe payment for 4 Seasons subscription -- CDC 7.3
- [ ] Stripe webhooks configured for real-time payment confirmation
- [ ] Stripe test mode functional for development
- [ ] Stripe receipts linked to Declia invoices (structure ready for M13)

---

## M5: Delivery Galleries

**Description:** Photo upload, gallery creation with sub-folders, secure client access, and browsing features.

**Dependencies:** M1, M2

**CDC Ref:** 4.1, 4.3

---

### M5-S1: Upload & gallery creation (admin)

**As a** photographer, **I want** to upload photos and create organized galleries **so that** I can deliver photos to my clients -- CDC 4.3.

**Acceptance criteria:**
- [ ] Bulk HD photo upload from desktop (drag & drop, multi-select)
- [ ] Gallery creation with name, associated client, session type
- [ ] Sub-folder organization per gallery (e.g., wedding: Preparations, Ceremony, Reception)
- [ ] Photographer chooses which folders to share with client
- [ ] Photos stored in Supabase Storage with signed URLs (security)

---

### M5-S2: Client gallery access

**As a** client, **I want** to access my gallery by password or via my account **so that** I can view my photos securely -- CDC 4.1.

**Acceptance criteria:**
- [ ] Simple gallery access via password (no account creation required)
- [ ] Access via full client account to see all galleries
- [ ] HD photos without watermark
- [ ] Access duration: 90 days (configurable), remaining days counter visible
- [ ] Photographer notified when client first opens gallery

---

### M5-S3: Gallery features (favorites, comments, download)

**As a** client, **I want** to mark favorites, comment and download my photos **so that** I can interact with my gallery and retrieve photos -- CDC 4.3.

**Acceptance criteria:**
- [ ] Favorite marking (heart) on individual photos
- [ ] Comments on photos (text, visible to photographer)
- [ ] Individual download, selection download, or full gallery download (ZIP)
- [ ] Photographer notified for each new comment
- [ ] Favorites and comments saved and visible in admin

---

### M5-S4: Gallery sharing with guests

**As a** client, **I want** to share my gallery with guests (family, friends) **so that** they can also view and order photos -- CDC 4.3.

**Acceptance criteria:**
- [ ] Client can share gallery link + password
- [ ] Guests access with same password, can view and order
- [ ] Guests navigate shared sub-folders
- [ ] Guest orders associated with the original gallery

---

### M5-S5: Expiration & gallery management

**As a** photographer, **I want** galleries to expire automatically after 90 days **so that** I manage my storage -- CDC 4.3.

**Acceptance criteria:**
- [ ] Automatic expiration after 90 days (access revoked, photos not immediately deleted)
- [ ] Automatic reminders before expiration (structure ready for M12 Last Chance campaign)
- [ ] Photographer can manually extend or close a gallery
- [ ] Admin view of all galleries with status (active, expired), client, dates

---

## M6: Client Space & Premium Experience

**Description:** Complete client account, visual Client Journey, premium Coffret Numerique delivery, Before/After retouching, and selection galleries.

**Dependencies:** M1, M2, M3, M4, M5

**CDC Ref:** 4.1, 4.2, 4.4, 4.5, 4.6

**Mockups:** `espace-client/10-espace-client.html`, `espace-client/01-client-journey.html`, `espace-client/04-coffret-numerique.html`, `espace-client/07-before-after.html`

---

### M6-S1: Complete client space

**As a** client, **I want** a personal space grouping all my information **so that** I can find everything in one place -- CDC 4.1.

**Acceptance criteria:**
- [ ] Client space shows: galleries (active and archived), bookings (past and upcoming), invoices and quotes, shop orders, loyalty program (placeholder for M8)
- [ ] Each section navigable and linked to corresponding features
- [ ] Client can edit personal info (name, email, phone, address)
- [ ] Communication preferences editable (email, SMS, opt-in/opt-out)
- [ ] Design consistent with public showcase (Rose Sauvage branding)

---

### M6-S2: Visual Client Journey

**As a** client, **I want** to see a progress bar showing where my service stands **so that** I can follow along without contacting the photographer -- CDC 4.2.

**Acceptance criteria:**
- [ ] Elegant progress bar at top of client space
- [ ] Steps adapted by session type: Family (Booking -> Questionnaire -> Shooting -> Retouching -> Gallery -> Prints -> Delivery), Wedding (Booking -> Questionnaire -> Meeting -> Day -> Retouching -> Gallery -> Album -> Delivery)
- [ ] Auto-updates when photographer completes a workflow task (link with M10)
- [ ] Push notifications to client at each step change
- [ ] Multi-session supported (client can have multiple simultaneous journeys)

---

### M6-S3: Coffret Numerique -- premium delivery

**As a** client, **I want** to discover my photos like a gift to unwrap **so that** I live a unique emotional experience -- CDC 4.5.

**Acceptance criteria:**
- [ ] **Screen 1 (Envelope):** dark, premium page with client's name, session type, "Open my coffret" button
- [ ] **Screen 2 (Content):** personalized photographer message (text + 30 sec audio), session recap, mosaic preview, gallery CTA, Avant-Premiere offer
- [ ] Admin: customizable message with variables, audio recording, cover photo selection, toggles per element
- [ ] Accessible via unique link sent by email
- [ ] Smooth, premium opening animation

---

### M6-S4: Before/After retouching

**As a** client, **I want** to compare the raw photo and the retouched version via an interactive slider **so that** I appreciate the retouching work -- CDC 4.6.

**Acceptance criteria:**
- [ ] Interactive slider in gallery to compare raw/retouched photo
- [ ] Tags of applied retouching visible
- [ ] Upsell CTA for additional retouching
- [ ] Photographer selects photos for Before/After mode from admin
- [ ] Responsive and smooth on mobile (touch gesture)

---

### M6-S5: Selection galleries

**As a** client, **I want** to select which photos to retouch in a dedicated gallery **so that** I indicate my preferences to the photographer -- CDC 4.4.

**Acceptance criteria:**
- [ ] Photographer sends a selection gallery to client
- [ ] Client browses photos and selects ones to retouch
- [ ] Real-time counter (e.g., 12/20 photos selected)
- [ ] Photographer instantly notified when selection is made
- [ ] Selection saved and visible in admin with summary

---

## M7: Integrated Shop

**Description:** Product catalog, contextual purchase from galleries, multi-product cart, Stripe payment and order management.

**Dependencies:** M1, M2, M5, M6

**CDC Ref:** 5.1, 5.2, 5.3

**Mockups:** `site-public/06-boutique.html`

---

### M7-S1: Product catalog (admin)

**As a** photographer, **I want** to manage a photo product catalog from admin **so that** I can offer prints and objects to my clients -- CDC 5.1.

**Acceptance criteria:**
- [ ] Manageable catalog: prints (postcard, 20x30, 30x40, 40x60, 60x80, 80x120), canvas/frames (mat, white frame, canvas, brushed aluminum), photo albums, objects (mugs, cushions, magnets, tote bags, keychains), video/montage
- [ ] Special product: "L'Ecrin Fleur de Lumiere" souvenir box (kraft box, engraved USB, 3 prints, handwritten note, flower seeds)
- [ ] Additional photos sold per unit
- [ ] Each product: name, description, price, image, available formats
- [ ] Photographer sets their own prices

---

### M7-S2: Contextual purchase from gallery

**As a** client, **I want** to click on a gallery photo and order a product directly **so that** I can turn my favorites into prints or objects -- CDC 5.2.

**Acceptance criteria:**
- [ ] Click on photo -> product choice menu (type, format, finish)
- [ ] Product preview with selected photo
- [ ] Add to cart in one click
- [ ] Multi-product cart (multiple photos, different products)
- [ ] Gallery guests can also order

---

### M7-S3: Cart & shop payment

**As a** client, **I want** to finalize my order and pay via Stripe **so that** I receive my photo products -- CDC 5.2.

**Acceptance criteria:**
- [ ] Summary cart with: photo, product, format, unit price, quantity
- [ ] Editable (quantity, removal)
- [ ] Promo code / offer application (link with M8)
- [ ] Payment via Stripe (card, Apple Pay, Google Pay)
- [ ] Order confirmation email to client

---

### M7-S4: Order management (admin)

**As a** photographer, **I want** to manage all orders from admin **so that** I can prepare and ship products -- CDC 5.3.

**Acceptance criteria:**
- [ ] Admin page listing all orders with status: pending -> preparing -> shipped -> delivered
- [ ] Status tracking with checkbox system at each stage
- [ ] Client notified at each status change
- [ ] Order detail: concerned photos, products, formats, shipping address
- [ ] Filtering by status, client, date

---

## M8: Gift Cards, Loyalty & Promotions

**Description:** Gift cards, loyalty program, referral, 4 Seasons subscription, and promotional offers system.

**Dependencies:** M1, M2, M3, M4, M7

**CDC Ref:** 6, 7.1, 7.2, 7.3, 8.1, 8.2

**Mockups:** `site-public/07-cartes-cadeau-faq.html`, `site-public/08-offres-legal.html`

---

### M8-S1: Gift cards

**As a** visitor, **I want** to buy a gift card for a photo session **so that** I can give an original gift -- CDC 6.

**Acceptance criteria:**
- [ ] 3 delivery modes: downloadable PDF, email delivery
- [ ] Personalization: message from the giver
- [ ] Unique code per card, configurable expiration date
- [ ] Payment via Stripe
- [ ] Beneficiary uses code during booking to apply the credit

---

### M8-S2: Gift card management center (admin)

**As a** photographer, **I want** to manage all gift cards from admin **so that** I can track sales and usage -- CDC 6.

**Acceptance criteria:**
- [ ] Overview: issued, used, expired, revenue generated
- [ ] Detail per card: code, amount, buyer, beneficiary, status, expiration date
- [ ] Manual gift card creation (e.g., offer to a loyal client)
- [ ] Automatic alerts before expiration (structure ready for M11)

---

### M8-S3: Loyalty program

**As a** client, **I want** to accumulate points with each purchase **so that** I get benefits -- CDC 7.1.

**Acceptance criteria:**
- [ ] Points or tier system rewarding recurring clients
- [ ] Points visible in client space
- [ ] Rules configurable from admin (points per euro spent, tier thresholds)
- [ ] Rewards definable by photographer (discount, free product, etc.)

---

### M8-S4: Referral system

**As a** client, **I want** to refer a friend and receive a benefit **so that** I help the photographer while being rewarded -- CDC 7.2.

**Acceptance criteria:**
- [ ] Unique referral link per client
- [ ] Both referrer and referee receive a benefit (configurable: % discount, fixed amount)
- [ ] Admin tracking: number of referrals, conversions, benefits distributed
- [ ] Not stackable with promotional offers
- [ ] CRM integration (referee linked to referrer)

---

### M8-S5: 4 Seasons subscription

**As a** client, **I want** to subscribe to an annual plan for regular sessions **so that** I benefit from an advantageous rate -- CDC 7.3.

**Acceptance criteria:**
- [ ] Recurring subscription via Stripe (480 EUR/year, monthly or quarterly payment)
- [ ] Includes one session per season (4 sessions/year)
- [ ] Subscription management in client space (status, next session)
- [ ] Admin: subscriber view, payment status, upcoming planned sessions

---

### M8-S6: Promotional offers system

**As a** photographer, **I want** to create varied promotional offers **so that** I can stimulate sales -- CDC 8.1, 8.2.

**Acceptance criteria:**
- [ ] Offer types: percentage discount, fixed amount, free product, promo code
- [ ] Configurable constraints: time-limited (start/end), quantity-limited (X spots), targeted (session type, client segment)
- [ ] Display: home page banner, arrival pop-up, email/SMS sending
- [ ] Not stackable: one offer at a time per client
- [ ] Full customization (text, visual, conditions)

---

## M9: Mini-Sessions & School Module

**Description:** Automated mini-session events with slot management, and Parent Gallery module for school photography.

**Dependencies:** M1, M2, M3, M4, M5, M7

**CDC Ref:** 10, 11

**Mockups:** `admin/11-mini-sessions.html`, `admin/07-scolaire-admin.html`, `admin/08-scolaire-ecole-parent.html`

---

### M9-S1: Mini-session event creation (admin)

**As a** photographer, **I want** to create a mini-session event via a 5-step guided form **so that** I can quickly configure a complete event -- CDC 11.1.

**Acceptance criteria:**
- [ ] 5-step form: Info -> Slots -> Options -> Visual -> Publish
- [ ] Automatic slot generation every 20 min with blockable breaks
- [ ] Options: waitlist on/off, auto pre-shooting guide, full payment required
- [ ] Calculates and displays total spots and potential revenue
- [ ] Draft status until published, then public URL generated

---

### M9-S2: Mini-session public page

**As a** visitor, **I want** to view a dedicated mini-session event page **so that** I can discover the offer and book a slot -- CDC 11.2.

**Acceptance criteria:**
- [ ] Hero visual, name, date, location, price, included recap
- [ ] Real-time urgency banner (remaining spots, Supabase Realtime)
- [ ] Clickable slot grid (booked slots grayed out)
- [ ] Social sharing buttons
- [ ] Responsive mobile-first, SEO optimized

---

### M9-S3: Mini-session booking & payment

**As a** client, **I want** to book and pay for a mini-session slot **so that** my spot is guaranteed -- CDC 11.2.

**Acceptance criteria:**
- [ ] Slot selection + info entry + full Stripe payment
- [ ] Slot marked as booked immediately (double-booking protection)
- [ ] If payment abandoned within 15 min, slot released
- [ ] Confirmation email + SMS
- [ ] Slot visible in photographer agenda and client space

---

### M9-S4: Mini-session waitlist

**As a** client, **I want** to join a waitlist when all slots are taken **so that** I'm notified if a spot opens.

**Acceptance criteria:**
- [ ] "Waitlist" button when all slots booked
- [ ] Registration with email + phone, confirmation sent
- [ ] If spot opens: first registrant notified (email + SMS) with 24h booking link
- [ ] If not booked within 24h, next person in queue
- [ ] Waitlist manageable from admin

---

### M9-S5: Mini-session dashboard (admin)

**As a** photographer, **I want** a mini-session dashboard **so that** I can track bookings and revenue -- CDC 11.3.

**Acceptance criteria:**
- [ ] Per event: slots booked/total, collected/potential revenue, waitlist count
- [ ] Client list with slot time, payment status, contact details
- [ ] Filter past/current/upcoming, CSV export
- [ ] Real-time updates (Supabase Realtime)

---

### M9-S6: School gallery creation (admin)

**As a** photographer, **I want** to create a school gallery by child/class **so that** parents can order online -- CDC 10.

**Acceptance criteria:**
- [ ] Creation: school name, class(es), date, upload photos by child
- [ ] Unique access code per child/class + gallery link
- [ ] Printable PDF generation (code + link + instructions) for distribution
- [ ] Photos secured, accessible only with correct code
- [ ] Admin view: children/class list with order status

---

### M9-S7: Parent journey -- school gallery

**As a** parent, **I want** to access my child's photos and order products **so that** I easily choose and receive school photos -- CDC 10.1, 10.2.

**Acceptance criteria:**
- [ ] Access via link + unique code, shows only the child's photos
- [ ] 4 packs: Serious photo only, Serious + funny, Essential Pack, Complete Pack
- [ ] Per-unit supplements: greeting cards, magnet, mug, tote bag, extra print
- [ ] Multi-product cart + Stripe payment, confirmation email
- [ ] No payment asked from the school

---

### M9-S8: School order management

**As a** photographer, **I want** to manage school orders grouped by school **so that** I optimize preparation and delivery -- CDC 10.

**Acceptance criteria:**
- [ ] Orders grouped by school and class with status
- [ ] Parent notified at each status change
- [ ] Summary per school: total orders, revenue, products to prepare (aggregated quantities)
- [ ] Bulk delivery marking "delivered to school" updates all related orders

---

## M10: Workflow & Task Automation

**Description:** Multi-view task management system with customizable workflow templates and Client Journey connection.

**Dependencies:** M1, M2, M4, M6

**CDC Ref:** 15.3

---

### M10-S1: Task management views

**As a** photographer, **I want** to view my tasks in 3 different views **so that** I choose the view that fits my workflow -- CDC 15.3.

**Acceptance criteria:**
- [ ] **Calendar** view: tasks on day/week/month, color-coded by status
- [ ] **List** view (to-do): grouped by period, checkbox to mark done, sortable by priority/date/client
- [ ] **Kanban** view: 3 columns (To do / In progress / Done) with drag-and-drop
- [ ] Switching views preserves applied filters
- [ ] Each task shows: title, client, session type, due date, status

---

### M10-S2: Detailed task management

**As a** photographer, **I want** to manage each task with status, subtasks and notes **so that** I can track progress precisely -- CDC 15.3.

**Acceptance criteria:**
- [ ] 3 statuses: To do, In progress, Done
- [ ] Subtask checklist with progress bar
- [ ] Internal notes per task
- [ ] Manual creation with title, description, due date, client, session type
- [ ] Marking "Done" auto-updates Client Journey on client side (link M6-S2)

---

### M10-S3: Workflow templates per session type

**As a** photographer, **I want** to define workflow templates per session type **so that** I don't recreate the same tasks for each booking -- CDC 15.3.

**Acceptance criteria:**
- [ ] Predefined templates per session type (family, equestrian, maternity, event, school, mini-session)
- [ ] Customizable: add/remove/reorder tasks, relative delays (D-3, D+1)
- [ ] Template duplication to create variants
- [ ] Editing a template doesn't affect already instantiated workflows
- [ ] Task-to-Client Journey step mapping configurable

---

### M10-S4: Automatic task creation on booking

**As a** photographer, **I want** tasks to be automatically created when a client books **so that** I never forget a step -- CDC 15.3.

**Acceptance criteria:**
- [ ] Confirmed booking -> auto-instantiation of workflow with dates calculated from shooting date
- [ ] Automated tasks (send email, reminder) trigger at scheduled date
- [ ] Manual tasks created with "To do" status
- [ ] Additional manual tasks can be added to an instantiated workflow
- [ ] Notification to photographer for tasks approaching deadline (D-1)

---

### M10-S5: Workflow-Client Journey connection

**As a** client, **I want** my progress bar to update automatically **so that** I know where my service stands -- CDC 4.2, 15.3.

**Acceptance criteria:**
- [ ] Task linked to Client Journey step marked done -> step auto-updates to "done" on client side
- [ ] Push notification to client at each step change
- [ ] Progress bar reflects real-time workflow completion
- [ ] Journey adapts to session type

---

## M11: Emails, SMS & Education Hub

**Description:** Automated communication system with customizable templates, dynamic variables, and pre-shooting guide library.

**Dependencies:** M1, M2, M4, M5, M10

**CDC Ref:** 12, 13, 14

**Mockups:** `admin/13-education-hub.html`

---

### M11-S1: Email template system

**As a** photographer, **I want** to customize each email template with dynamic variables **so that** my automated messages don't feel generic -- CDC 12.

**Acceptance criteria:**
- [ ] Rich text email editor with variable insertion ({first_name}, {session_type}, {date}, {gallery_link}, etc.)
- [ ] Customizable subject and body, preview with test data
- [ ] Signature branded to photographer's colors with social links
- [ ] Email history in CRM profile (status: sent, read, clicked)
- [ ] Default templates provided in French and freely editable

---

### M11-S2: Booking-related emails

**As a** client, **I want** to receive automatic emails at each key booking step **so that** I'm guided throughout the process -- CDC 12.1.

**Acceptance criteria:**
- [ ] Confirmation email after payment (booking recap, questionnaire link, client space link)
- [ ] Pre-shooting questionnaire (sent with confirmation or separately, configurable)
- [ ] Education Hub preparation guide (sent by session type, configurable timing)
- [ ] D-3 reminder (practical recap, last-minute tips)
- [ ] Each email togglable and timing configurable

---

### M11-S3: Gallery-related emails

**As a** client, **I want** to be notified by email when my gallery is ready and before it expires **so that** I don't miss access to my photos -- CDC 12.2.

**Acceptance criteria:**
- [ ] Gallery ready (Coffret Numerique): personalized message + link
- [ ] Expiration reminder: configurable tiers (D-30, D-7, D-1), progressively urgent tone
- [ ] Abandoned cart recovery: trigger after 4h (configurable)
- [ ] Each email with direct CTA to gallery or cart

---

### M11-S4: Post-shooting emails

**As a** photographer, **I want** to automatically send follow-up emails **so that** I collect reviews and testimonials -- CDC 12.3.

**Acceptance criteria:**
- [ ] Session Recap: auto email after mobile form submission
- [ ] Satisfaction email: X days after delivery (configurable delay)
- [ ] Testimonial request: if positive rating (configurable threshold), proposes site testimonial + Google review
- [ ] Submitted testimonial saved as "pending moderation"

---

### M11-S5: Automated SMS

**As a** photographer, **I want** to send SMS for key moments **so that** important messages are read quickly -- CDC 12.4.

**Acceptance criteria:**
- [ ] SMS for: D-1 reminder, gallery ready, last chance (D-1 expiration), gallery wake-up (unopened 72h)
- [ ] Explicit opt-in consent required (timestamped)
- [ ] Customizable SMS templates with variables, 160 character counter
- [ ] SMS history visible in CRM profile
- [ ] Test send to photographer's own number

---

### M11-S6: Education Hub -- preparation guides

**As a** client, **I want** to receive an interactive preparation guide for my session **so that** I feel ready on shooting day -- CDC 14.

**Acceptance criteria:**
- [ ] 9 templates: Family, Equestrian, Wedding, Maternity, Newborn, School, Lifestyle, Corporate, Mini-Session
- [ ] Content: outfit tips + suggested color palette, day-J preparation, interactive checkable checklist
- [ ] Personalized photographer message as header
- [ ] Configurable send timing (immediate, D-14 weddings, D-3 reminder)
- [ ] Accessible via email link and from client space, mobile responsive

---

## M12: Marketing Automation V1

**Description:** 6 automated marketing campaigns with performance dashboard and CRM-powered targeting.

**Dependencies:** M1, M2, M5, M7, M8, M10, M11

**CDC Ref:** 9.1, 13, 17

**Mockups:** `admin/09-marketing-automation.html`, `admin/12-session-recap.html`, `admin/14-referral-proof.html`

---

### M12-S1: Avant-Premiere campaign

**As a** photographer, **I want** to automatically launch a time-limited offer when a gallery is published **so that** I encourage quick orders -- CDC 9.1.

**Acceptance criteria:**
- [ ] Auto-trigger on gallery publication, configurable duration per session type (7d mini, 14d family, 21d wedding)
- [ ] Configurable discount (%, fixed amount, free product, free shipping)
- [ ] Promo banner with real-time degressive countdown in gallery
- [ ] Sequence: email D0 -> email mid-course -> SMS D-1 -> email last day
- [ ] Togglable per session type, orders tagged for tracking

---

### M12-S2: Abandoned Cart campaign

**As a** photographer, **I want** to automatically follow up on abandoned carts **so that** I recover lost sales -- CDC 9.1.

**Acceptance criteria:**
- [ ] Detection of unfinalized cart after 4h (configurable), email with product preview + CTA
- [ ] Optional flash promo code on first email
- [ ] 2nd reminder at 48h, optional supplementary SMS
- [ ] Auto-stop if purchase completed, conversion recorded
- [ ] Each step togglable

---

### M12-S3: Last Chance campaign

**As a** photographer, **I want** to automatically send reminders before gallery expiration **so that** I maximize orders -- CDC 9.1.

**Acceptance criteria:**
- [ ] 3 tiers: D-30 (soft reminder), D-7 (urgency + optional offer), D-1 (SMS)
- [ ] Each tier independently togglable
- [ ] Customizable messages, progressively urgent tone
- [ ] Optional promo offer on D-7 tier
- [ ] Not sent to clients who already ordered

---

### M12-S4: Gallery Wake-up campaign

**As a** photographer, **I want** to automatically re-engage inactive gallery clients **so that** I recover engagement -- CDC 9.1.

**Acceptance criteria:**
- [ ] Scenario 1: gallery never opened after 72h -> email + SMS with Coffret link
- [ ] Scenario 2: gallery opened but no orders after 14d -> email with popular products
- [ ] "Gallery opened" tracking recorded in database
- [ ] Each scenario independently togglable
- [ ] Not sent if client already ordered

---

### M12-S5: Session Recap (mobile form)

**As a** photographer, **I want** to fill a quick mobile form right after each shooting **so that** I capture info while fresh and trigger follow-up -- CDC 13.

**Acceptance criteria:**
- [ ] Mobile form: mood (emoji), photo count, light conditions (tags), highlight (visible to client), estimated delivery date, private internal note
- [ ] Fills in < 2 minutes
- [ ] Auto-triggers: client email (visible recap), SMS, Client Journey update, workflow task creation, CRM note
- [ ] Preview before submission
- [ ] Recap viewable in CRM profile

---

### M12-S6: Referral Proof -- social proof

**As a** photographer, **I want** to display social proof indicators on my site **so that** I reassure prospects -- CDC 17.

**Acceptance criteria:**
- [ ] Public counters: client count, average rating, referral rate, loyalty rate
- [ ] Geolocated map with anonymized session location dots
- [ ] Real-time anonymized activity feed
- [ ] Featured testimonial with Google badge
- [ ] Admin toggles on/off per element

---

### M12-S7: Marketing campaign dashboard

**As a** photographer, **I want** a campaign performance dashboard **so that** I can evaluate effectiveness -- CDC 9.1.

**Acceptance criteria:**
- [ ] Per campaign: generated revenue, emails/SMS sent, open rate, conversion rate
- [ ] Toggle on/off to activate/deactivate each campaign
- [ ] Filter by period and session type
- [ ] CRM targeting visibility (segments reached)

---

## M13: Invoicing & Accounting Export

**Description:** Factur-X quotes and invoices, payment tracking, financial dashboard, URSSAF module and accounting exports.

**Dependencies:** M1, M2, M4, M7

**CDC Ref:** 15.4, 15.5

**Mockups:** `admin/02-facturation.html`, `admin/10-export-comptable.html`

---

### M13-S1: Automatic quote generation

**As a** photographer, **I want** to generate professional quotes **so that** I can quickly respond to event requests -- CDC 15.4.

**Acceptance criteria:**
- [ ] Creation from admin: client, session type, formulas/options, free-form lines
- [ ] Auto sequential number (DEV-2026-001), mandatory legal mentions
- [ ] Send by email, online validation and deposit payment (Stripe)
- [ ] Statuses: draft, sent, accepted, refused, expired
- [ ] Accepted quote + paid deposit -> booking automatically created

---

### M13-S2: Automatic invoice generation

**As a** photographer, **I want** invoices generated automatically on each payment **so that** I stay compliant -- CDC 15.4.

**Acceptance criteria:**
- [ ] Invoice auto-generated at each confirmed payment
- [ ] Unique sequential number without gaps (FA-2026-0001)
- [ ] All mandatory legal mentions, VAT or "article 293B CGI" mention
- [ ] PDF + Factur-X format (PDF/A-3 with embedded XML), PDP/PPF compatible
- [ ] Automatic archiving 10 years minimum (Supabase Storage)

---

### M13-S3: Payment tracking

**As a** photographer, **I want** to track payment status per client **so that** I know who still owes me -- CDC 15.4.

**Acceptance criteria:**
- [ ] Per booking/order: deposit received (30%), balance pending, fully paid
- [ ] Record offline payments (POS terminal, cash, bank transfer)
- [ ] "Pending payments" view with amount, client, days since deposit
- [ ] Late payments highlighted + photographer notification
- [ ] Invoices linked to CRM profile and downloadable by client

---

### M13-S4: Financial dashboard

**As a** photographer, **I want** to visualize revenue and financial trends **so that** I can steer my business -- CDC 15.5.

**Acceptance criteria:**
- [ ] Monthly, quarterly, annual revenue with trend charts (Y vs Y-1)
- [ ] Revenue breakdown by session type with average cart per type
- [ ] URSSAF self-employed module: annual revenue ceiling progress (visual bar with alert threshold), estimated contributions, declaration deadline alerts
- [ ] Print/product revenue separate from session revenue

---

### M13-S5: Accounting exports

**As a** photographer, **I want** to export financial data in various formats **so that** I can send them to my accountant -- CDC 15.5.

**Acceptance criteria:**
- [ ] CSV receipt book export (regulatory format)
- [ ] Printable PDF export
- [ ] Pennylane/Indy compatible export
- [ ] URSSAF summary export (quarterly revenue, contributions, declaration dates)
- [ ] Each export filterable by period, downloadable in one click

---

## M14: Statistics, Notifications & Referral Proof

**Description:** Complete statistics dashboard, multi-platform push notifications, and social proof integration on the showcase.

**Dependencies:** M1, M2, M4, M5, M7, M8, M12, M13

**CDC Ref:** 15.6, 16

**Mockups:** `admin/19-statistiques.html`, `espace-client/03-notifications.html`

---

### M14-S1: Global KPI dashboard

**As a** photographer, **I want** a complete dashboard with all key indicators **so that** I make informed decisions -- CDC 15.6.

**Acceptance criteria:**
- [ ] Global + monthly revenue with trend, revenue by session type, sessions done/upcoming, visitor->booking conversion
- [ ] Product metrics: print vs session revenue, average cart, print order rate, top 5 products
- [ ] Gift card metrics: sold/used/expired, revenue generated
- [ ] Engagement: seasonality, acquisition source, booking->shooting delay, loyalty rate
- [ ] Daily stats, period filtering

---

### M14-S2: Multi-platform push notifications

**As a** photographer, **I want** to receive real-time push notifications **so that** I react quickly to important events -- CDC 16.

**Acceptance criteria:**
- [ ] Push on mobile iOS/Android, desktop web, tablet (Firebase Cloud Messaging)
- [ ] Events: new booking, payment received, gallery comment, product order, gallery expiring, late payment, gift card used/expired, cancellation/reschedule, client viewed gallery, client made selection
- [ ] Each type individually togglable
- [ ] Click on notification opens contextual page
- [ ] Notification center with read/unread history and filters

---

### M14-S3: Notification preferences

**As a** photographer, **I want** to finely configure my notifications **so that** I'm not overwhelmed -- CDC 16.

**Acceptance criteria:**
- [ ] Toggle on/off per notification type
- [ ] Channel selection per type: mobile push, desktop push, recap email
- [ ] "Do not disturb" mode with configurable time range (e.g., 10pm-7am)
- [ ] Preferences synced across all connected devices

---

### M14-S4: Referral Proof showcase integration

**As a** photographer, **I want** social proof elements displayed on my public site **so that** I convert more visitors -- CDC 17.

**Acceptance criteria:**
- [ ] Referral Proof counters integrated on home page
- [ ] Featured testimonial on home and testimonials pages
- [ ] Real-time activity feed widget (discreet bottom pop-up, togglable)
- [ ] Data auto-calculated from CRM and satisfaction system
- [ ] Admin controls what's visible on public showcase

---

## M15: Security, GDPR & Launch

**Description:** Final security hardening, GDPR compliance, SEO, messaging center, admin content management, and performance optimization for production launch.

**Dependencies:** M1-M14

**CDC Ref:** 23, 15.9, 15.10

**Mockups:** `admin/03-parametres-1.html`, `admin/04-parametres-2.html`, `admin/05-personnalisation.html`

---

### M15-S1: Infrastructure security

**As a** photographer, **I want** the platform secured against common attacks **so that** my data and my clients' data are protected -- CDC 23.1.

**Acceptance criteria:**
- [ ] HTTPS enforced everywhere (SSL, HTTP->HTTPS redirect)
- [ ] Automatic daily database backups (30-day retention, tested restore procedure)
- [ ] Sensitive data encrypted at rest (AES-256 via Supabase)
- [ ] Protections: auth rate limiting (anti brute force), parameterized queries (anti SQL injection), input sanitization (anti XSS), CSP headers, CSRF protection
- [ ] Passwords bcrypt hashed, session tokens with limited lifetime

---

### M15-S2: GDPR compliance

**As a** visitor/client, **I want** my personal data handled in compliance with GDPR **so that** I can exercise my rights -- CDC 23.2.

**Acceptance criteria:**
- [ ] Compliant cookie banner (accept all, refuse all, customize), no non-essential cookies before consent
- [ ] Complete privacy policy (data collected, purposes, retention, rights, contact)
- [ ] Rights exercisable from client space: access (download data), modification, deletion (with confirmation)
- [ ] Separate explicit consent per treatment (marketing email, SMS, image rights) with timestamps
- [ ] Treatment registry maintained in admin

---

### M15-S3: SEO finalization

**As a** photographer, **I want** my site optimized for search ranking **so that** I appear in Google results -- CDC 23.3.

**Acceptance criteria:**
- [ ] Editable meta tags per page (title max 60, description max 160, Open Graph, image alt)
- [ ] Auto-generated XML sitemap, submitted to search engines
- [ ] Clean readable URLs (/family-session-toulouse, /portfolio/equestrian)
- [ ] Google My Business prepared (consistent NAP, Google review link integrated)
- [ ] Core Web Vitals in "good" range (LCP < 2.5s, FID < 100ms, CLS < 0.1)

---

### M15-S4: Messaging center

**As a** photographer, **I want** to manage all client exchanges from a centralized inbox **so that** I don't miss any message -- CDC 15.10.

**Acceptance criteria:**
- [ ] Unified interface: contact form emails, gallery comments, quote requests, order exchanges
- [ ] Conversations linked to CRM client profile with full history
- [ ] Reply directly from messaging center (sent as email to client)
- [ ] Unread count in admin nav menu
- [ ] Filter by type (contact, gallery, quote, order) and status (unread, read, handled)

---

### M15-S5: Showcase content management (admin)

**As a** photographer, **I want** to manage my public showcase content from admin **so that** I can update without technical help -- CDC 15.9.

**Acceptance criteria:**
- [ ] Portfolio: upload, organize by gallery/specialty, feature selection, drag-and-drop reordering
- [ ] Testimonials: moderation (approve/reject), featuring, editing
- [ ] Pricing: modify prices, add/remove formulas and options
- [ ] Seasonal mode: upload visuals mapped to date ranges
- [ ] Preview before publishing

---

### M15-S6: Performance optimization & launch

**As a** user (photographer or client), **I want** a fast and reliable platform **so that** I have a smooth experience.

**Acceptance criteria:**
- [ ] Gallery images served via CDN with auto-transforms (thumbnails, responsive sizes, WebP)
- [ ] Initial page load < 3s on 4G mobile (Lighthouse measurement)
- [ ] Lazy loading on all gallery/portfolio images
- [ ] Custom domain configured (DNS, SSL, redirects)
- [ ] End-to-end test suite covering critical paths: signup/login, full booking with payment (Stripe test mode), gallery browsing, shop order, client space, contact form
- [ ] Production monitoring: server error alerts, performance metrics, uptime surveillance

---

## Verification

To validate the deliverable:
1. Reread `agent-os/product/roadmap-v1.md` after creation and verify consistency with CDC.2
2. Verify every V1 feature from the current roadmap is covered by at least one milestone
3. Verify no V1.5 or V2 features have been included
4. Verify milestone dependencies are consistent (no circular references)
5. Verify `agent-os/product/roadmap.md` contains the reference link to the new file
