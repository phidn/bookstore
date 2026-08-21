# 📚 Tiểu Viện Hữu Thư — Bookstore

A modern, minimalist, and high-performance online bookstore platform. Built on **Astro (SSR)**, powered by **Cloudflare Workers (D1, R2, KV)**, and styled with **shadcn/ui** and **Tailwind CSS v4**.

---

## 📸 Screenshots & Preview

| **Storefront (Catalog & Search)** | **Checkout & Payment Flow** |
| :---: | :---: |
| ![Storefront](docs/media/storefront.png) | ![Checkout](docs/media/checkout.png) |
| *Modern, responsive catalog with full-text search* | *Frictionless checkout supporting COD & Bank Transfer* |
| **Admin Management Portal** | **Telegram Bot & Turnstile Settings** |
| ![Admin Portal](docs/media/admin.png) | ![Telegram & Turnstile Settings](docs/media/telegram-turnstile.png) |
| *Comprehensive book, stock & order management* | *Cloudflare Turnstile CAPTCHA & Telegram Bot configuration* |
| **Telegram Order Notifications** | **Real-Time Alert Features** |
| ![Telegram Order Notification](docs/media/telegram-notification.png) | • **Instant Alerts**: Real-time push notification for every new order<br>• **Order Breakdown**: Total price, items, quantity & customer email<br>• **Direct Action Link**: One-click jump to order details in Admin<br>• **Topic Support**: Flexible routing to Telegram supergroups & forum topics |

---

## ✨ Key Features

- **⚡ Blazing Fast Performance**: Server-Side Rendered (SSR) with near-zero client-side JavaScript, instant page loads, and fully responsive across mobile, tablet, and desktop.
- **🏷️ Smart Catalog & Full-Text Search**: Filter by categories (Business, Science, Psychology, Philosophy, etc.), sort by price / name / publication date, with SQLite FTS5 Full-Text Search.
- **🛒 Frictionless Cart & Flexible Checkout**: Lightweight client cart, Cash on Delivery (COD), and direct Bank Transfer payment flows.
- **📦 Inventory & Product Management**: Manage book metadata, real-time inventory tracking (In Stock / Low / Sold Out), pricing, cover media, and visibility toggles.
- **📑 Custom Markdown Pages**: Create and publish static pages (About Us, Shipping Policy, Terms of Service) using Markdown with live preview and built-in XSS protection.
- **🔔 Multi-Channel Notifications**: Real-time order alerts via **Telegram Bot API** and **Email** (Resend).
- **🛡️ Enterprise-Grade Security**: Fail-closed Admin portal with PBKDF2 password hashing / Cloudflare Access, brute-force protection via Cloudflare Turnstile, and rate limiting.
- **🤖 Built-in MCP Support**: Integrated Model Context Protocol (MCP) server for seamless AI assistant tooling and automation.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Frontend & Framework** | [Astro](https://astro.build) (SSR) + [React](https://react.dev) |
| **UI Components & Styling** | [shadcn/ui](https://ui.shadcn.com), [Tailwind CSS v4](https://tailwindcss.com), [Lucide React](https://lucide.dev) |
| **Edge Compute** | [Cloudflare Workers](https://workers.cloudflare.com/) |
| **Database** | [Cloudflare D1](https://developers.cloudflare.com/d1/) (Edge SQLite) |
| **Media & Asset Storage** | [Cloudflare R2](https://developers.cloudflare.com/r2/) |
| **Notifications & Anti-Abuse** | Telegram Bot API, Resend, Cloudflare Turnstile |

---

## 🚀 Getting Started & Local Development

### Prerequisites

- **Node.js**: ≥ 22.12 (Node 22 LTS recommended)
- **Package Manager**: `npm` or `pnpm`

### Installation & Setup

1. **Clone the repository and install dependencies:**
   ```bash
   git clone <repo-url>
   cd bookstore
   npm install
   ```

2. **Provision local environment (D1 migrations & seed data):**
   ```bash
   npm run provision:local -- --seed
   ```

3. **Start the development server:**
   ```bash
   npm run dev
   ```

4. **Access the application:**
   - **Storefront**: [http://localhost:4321](http://localhost:4321)
   - **Admin Portal**: [http://localhost:4321/admin](http://localhost:4321/admin)
   - **Cloudflare Local Explorer**: [http://localhost:4321/cdn-cgi/explorer](http://localhost:4321/cdn-cgi/explorer)

---

## 📋 Common Scripts & Administration

| Command | Description |
|---|---|
| `npm run dev` | Start Astro local development server |
| `npm run build` | Build the application for production |
| `npm run preview` | Run production build locally with Wrangler |
| `npm test` | Run test suite with Vitest |
| `npm run verify` | Full verification pipeline (Lint, Typecheck, Build, Tests) |
| `npm run db:migrate` | Apply database migrations to local D1 |
| `npm run db:migrate:remote` | Apply database migrations to Cloudflare D1 production |
| `npm run admin:reset` | Reset Admin credentials in local environment |
| `npm run admin:reset:remote` | Reset Admin credentials in remote production |
| `npm run deploy` | Deploy application to Cloudflare Workers |

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
