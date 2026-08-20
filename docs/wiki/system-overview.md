# System Overview & Architecture

## 1. Executive Summary
**bookstore** is a lightweight, high-performance, full-Cloudflare e-commerce platform and agent-ready storefront. It is built with Astro SSR running on Cloudflare Workers, Cloudflare D1 (SQLite), Cloudflare R2 for zero-egress object storage, and supports multiple payment rails (Stripe Checkout, Bitcoin Lightning, OpenNode, Demo). It natively supports both human shoppers (via an HTML-first, near-zero JS UI) and AI agents (via a public REST API and a standalone Model Context Protocol server).

---

## 2. Technology Stack

| Layer | Technology | Details |
|---|---|---|
| **Runtime & Hosting** | Cloudflare Workers | Edge serverless execution via `@astrojs/cloudflare` |
| **Framework** | Astro 5/7 (SSR mode) | Server-rendered components, progressive enhancement |
| **Database** | Cloudflare D1 | Embedded distributed SQLite with FTS5 search support |
| **Storage** | Cloudflare R2 | S3-compatible zero-egress bucket for media and product assets |
| **Styling** | Tailwind CSS v4 | `@tailwindcss/vite`, CSS design tokens per theme |
| **Payments** | Stripe, Lightning, OpenNode, Demo | Pluggable ports & adapters with D1 secret encryption |
| **Agent / MCP** | Model Context Protocol (MCP) | Autonomous store operation and catalog purchasing |
| **Testing** | Vitest + AstroContainer | Unit testing and storefront rendering equivalence tests |

---

## 3. Directory Layout & Feature Slices

The codebase follows a vertical feature slice structure where each feature folder owns its queries, types, and logic:

```
src/
  config.ts              # Upstream schema & defaults; getConfig() is the truth source
  store.config.ts        # Build-time store overrides (deep-merged on top)
  styles/overrides.css   # Post-theme CSS overrides
  middleware.ts          # Fail-closed Admin authentication gate
  env.d.ts               # Cloudflare.Env binding and secret types
  layouts/               # Layout.astro (Storefront), AdminLayout.astro
  features/              # Feature slices (each self-contained)
    products/            # Product catalog, stock, search, slug, form
    orders/              # Order management, numbering, atomic stock reservations
    payments/            # PaymentProvider port, adapters (Stripe, Lightning, OpenNode, Demo)
    shipping/            # Zones, weight bands, ShippingCalculator port
    storage/             # StorageProvider port, R2 adapter
    email/               # EmailProvider port, Resend / Cloudflare Email adapters
    auth/                # CF Access, Session cookies, Turnstile bot protection
    catalog/             # Public serialization shapes for /api/products
    cart/                # HttpOnly cookie-based cart
    categories/          # Hierarchical nested categories
    customers/           # Customer records & authentication
    media/               # Single ownership of R2 file uploads & reference counts
    pages/               # Merchant Markdown pages with layout presets
  pages/                 # Astro route handlers
    index, products/[slug], categories/[slug], pages/[slug], search, cart, checkout
    pay/[publicId]       # Lightning invoice polling page
    order/[token]        # Order confirmation and deliverable download
    admin/               # Administrative CRUD dashboard
    api/                 # Internal & Public APIs (cart, webhook, admin/*, checkout, products)
    images/[...key]      # R2 media proxy
```

---

## 4. Architectural Invariants

1. **Near-Zero Client JS:** Server-render everything. Plain forms with progressive enhancement for cart drawer, live search, and invoice polling.
2. **Paid-Only Orders:** The `orders` table only holds settled transactions. Pending Lightning invoices live in `pending_payments`.
3. **Dual-Layer Configuration:** Operational runtime settings live in D1 (`settings` table), while compile-time defaults live in `config.ts` and `store.config.ts`.
4. **Ports & Adapters Core:** Business logic and checkout flows only interact with abstract interfaces (`PaymentProvider`, `StorageProvider`, `EmailProvider`, `SearchProvider`).
5. **Fail-Closed Admin:** In production, missing credentials lock the admin down rather than leaving it open.
6. **Additive Migrations:** SQL migrations in `migrations/` are numbered, additive (`CREATE TABLE IF NOT EXISTS`, `ALTER TABLE ADD COLUMN`), and never rewritten.
7. **Minor Units for Money:** Currency amounts are stored and calculated as integer minor units (cents, satoshis) to prevent float inaccuracies.
8. **Media Single Ownership:** Uploaded files in R2 are strictly managed through `features/media`. Other entities only reference `image_key`.
