# Storefront Customization Guide

## 1. The Customization Ladder

Always use the narrowest customization layer suitable for your change:

1. **Admin → Settings (Runtime, D1):** Store name, time zone, currency display, toggles, payment keys, email settings, search engine. Applied instantly without redeploy.
2. **`src/store.config.ts` (Build-Time):** Currency code, shipping zones and rate bands, image dimensions, order numbering, template flags. Only override changed keys; never touch `src/config.ts` defaults directly.
3. **`src/themes/<theme>/tokens.css` (Visual Design Tokens):** Colors, typography, borders, radii, container widths. `src/styles/overrides.css` is applied after theme tokens for targeted overrides.
4. **`public/favicon.svg` & Media:** Favicon, logo, and product images (uploaded through Admin / R2).
5. **`wrangler.jsonc` (Infrastructure):** Optional Cloudflare bindings (Vectorize, AI, Email, Turnstile).

---

## 2. Store-Owned Surface vs Upstream Core

| Store-Owned (Safe to Customize) | Upstream Core (Do Not Modify Directly) |
|---|---|
| `src/themes/<theme>/` | `src/features/` (Presentation models, business logic) |
| `src/themes/<theme>/Header.astro` | `src/layouts/Layout.astro` |
| `src/themes/<theme>/Footer.astro` | `src/styles/base.css`, `src/styles/global.css` |
| `src/themes/<theme>/ProductCard.astro` | `src/pages/` (Routing and endpoints) |
| `src/themes/<theme>/Catalog.astro` | Core database schemas & migrations |
| `src/themes/<theme>/ProductDetail.astro` | Payment and checkout controllers |
| `src/themes/<theme>/tokens.css` | Storage & encryption vaults |

---

## 3. Key Component Contracts

### ProductCard (`ProductCard.astro`)
Receives an already-resolved `ProductCardModel`:
```ts
interface ProductCardModel {
  id: string;              // prod_ public ID
  name: string;
  href: string;            // root-relative URL
  image: StorefrontImage;  // pre-resolved src, srcset, sizes, alt, priority
  formattedPrice: string;  // pre-formatted currency string
  inStock: boolean;        // availability indicator
}
```
*Rule:* Do not recompute prices or fetch raw image URLs manually; always render images using `<StoreImage>` control to preserve aspect ratios and LCP optimizations.

### Header & Shell (`Header.astro`, `Footer.astro`)
Receives `StorefrontShellModel` containing navigation links, store branding, and feature toggles (`search`, `cart`, `account`, `blog`). The header is rendered across all pages (including checkout and admin login), so core interactive controls must remain accessible.

---

## 4. Markdown Pages & Presets

- Merchant content pages are authored in Markdown in Admin (`/admin/pages`).
- Rendered safely with `html: false` on the server.
- Layout presets (`standard`, `narrow`, `wide`, `editorial`) are defined in `src/features/pages/layouts.ts`.
