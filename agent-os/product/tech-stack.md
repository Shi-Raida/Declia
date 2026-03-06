# Declia — Tech Stack

## Frontend

**Flutter (Dart)**
- Single codebase targeting mobile (iOS, Android), tablet, and desktop/web
- Mobile-first design — primary client touchpoint is smartphone
- Responsive layouts adapted for tablet and desktop back-office use

## Backend

**Supabase**
- **PostgreSQL** — primary relational database (clients, sessions, orders, invoices, etc.)
- **Auth** — user authentication (photographers + their clients), role-based access
- **Storage** — photo gallery storage, document storage (invoices, contracts)
- **Edge Functions** — serverless business logic (webhooks, automation triggers, integrations)
- **Realtime** — live updates for notifications, workflow status

## Payments

**Stripe**
- Card payments (CB, Visa, Mastercard)
- Apple Pay & Google Pay
- Recurring subscriptions (SaaS photographer subscriptions)
- One-time payments (sessions, shop orders, gift cards)
- Stripe Connect (future: marketplace payouts if needed)

## Integrations & Services

| Service | Usage |
|---|---|
| Google Calendar | Two-way sync for session scheduling |
| Google Reviews | Display client reviews on vitrine publique |
| Email automation | Transactional + marketing campaigns (SMTP/ESP) |
| SMS automation | Automated SMS notifications and campaigns |
| CDN | Fast image delivery for client galleries |
| Factur-X | French e-invoicing standard compliance |

## Compliance & Standards

- **RGPD** — data residency, consent management, right to deletion, client data portability
- **Factur-X** — structured PDF invoicing required for French B2B compliance
- **SEO** — server-side rendering or pre-rendering for vitrine publique pages
- **Security** — end-to-end encryption for gallery delivery links, signed URLs for private photos
