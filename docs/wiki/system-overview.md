# System Overview & Architecture

## 1. Executive Summary & Design Philosophy

**Tiểu Viện Hữu Thư (bookstore)** là nền tảng thương mại điện tử hiện đại, tối giản và hiệu năng cao, được thiết kế chạy 100% trên hạ tầng serverless tại biên (**Cloudflare Edge Network**).

### Triết lý kiến trúc cốt lõi:
- **Serverless & Zero-Cold-Start:** Vận hành hoàn toàn trên Cloudflare Workers, Cloudflare D1 (SQLite phân tán) và Cloudflare R2 (Object Storage không phí egress).
- **HTML-First & Near-Zero JS:** Render phía máy chủ (SSR) qua Astro, ưu tiên Progressive Enhancement cho trải nghiệm người dùng tức thì.
- **Ports & Adapters (Hexagonal Architecture):** Tách biệt logic nghiệp vụ khỏi các dịch vụ bên ngoài (thanh toán, lưu trữ, email, thông báo).
- **Agent-Ready & Dual Interface:** Sẵn sàng phục vụ đồng thời cả người dùng duyệt web lẫn các AI Agent tự hành thông qua Public REST API và Standalone Model Context Protocol (MCP) Worker.
- **Fail-Closed Security & Secret Vault:** Bảo vệ nghiêm ngặt khu vực Admin và mã hóa toàn bộ API keys/secrets của bên thứ ba bằng WebCrypto AES-GCM.

---

## 2. Technology Stack

| Tầng (Layer) | Công nghệ | Chi tiết vai trò |
|---|---|---|
| **Runtime & Hosting** | Cloudflare Workers | Edge serverless runtime thông qua `@astrojs/cloudflare` |
| **Framework** | Astro 5/7 (SSR mode) | Server-side rendering, component-driven UI |
| **Admin UI & Islands** | React 19 + shadcn/ui | Giao diện quản trị, Tailwind CSS v4, Lucide Icons |
| **Database** | Cloudflare D1 | SQLite phân tán tại Edge, tích hợp FTS5 Full-Text Search |
| **Media & Assets** | Cloudflare R2 | S3-compatible private bucket cho ảnh sản phẩm & tệp số |
| **Payment Rails** | Stripe, Lightning, OpenNode, COD, Bank | Cổng thanh toán đa dạng theo mô hình Ports & Adapters |
| **Notifications** | Telegram Bot API, Resend, Cloudflare Email | Thông báo đơn hàng tức thì cho merchant & khách hàng |
| **Agent / MCP** | Model Context Protocol (`@modelcontextprotocol/sdk`) | Worker MCP độc lập phục vụ AI Buyer & AI Operator |
| **Testing & Quality** | Vitest + TypeScript Strict | Unit tests, contract tests và verification suite |

---

## 3. High-Level System Architecture

Sơ đồ tổng quan luồng dữ liệu và hạ tầng biên giữa người dùng, AI Agent, Cloudflare Edge và các dịch vụ bên thứ ba:

```mermaid
flowchart TB
    subgraph Clients[" 👥 Clients & Consumers "]
        Shopper["🌐 Human Shopper<br/>(Browser / Mobile)"]
        AgentBuyer["🤖 AI Agent (Buyer)<br/>(Autonomous Purchase)"]
        Merchant["🧑‍💼 Merchant / Admin<br/>(Browser Portal)"]
        AgentOp["🤖 AI Agent (Operator)<br/>(Store Management)"]
    end

    subgraph CFEdge[" ☁️ Cloudflare Edge Network "]
        EdgeRouting["Cloudflare CDN / WAF / Turnstile"]
        
        subgraph ComputeLayer[" Compute Layer (Cloudflare Workers) "]
            AstroApp["⚡ Astro SSR Worker<br/><code>bookstore</code><br/>- Storefront SSR (HTML/CSS)<br/>- Admin Portal (React / shadcn)<br/>- Public Agent REST API (/api/*)<br/>- Webhook Ingestion (/api/webhook/*)"]
            MCPWorker["🧠 Standalone MCP Worker<br/><code>bookstore-mcp</code><br/>- Buyer Tier (Public Tools)<br/>- Operator Tier (Bearer Auth)"]
        end

        subgraph DataLayer[" Storage & Data Layer "]
            D1[("🗄️ Cloudflare D1<br/>(Distributed SQLite + FTS5)<br/>- Products, Orders, Categories<br/>- Encrypted Secret Vault")]
            R2[("📦 Cloudflare R2 Bucket<br/>(Zero-Egress Object Storage)<br/>- Product Images<br/>- Digital Deliverables")]
        end
    end

    subgraph ExternalServices[" 🔌 External Services & Third Parties "]
        Stripe["💳 Stripe Checkout & Webhooks"]
        Lightning["⚡ Bitcoin Lightning<br/>(phoenixd / LNbits / OpenNode)"]
        Telegram["💬 Telegram Bot API<br/>(Order Alerts to Group/Topic)"]
        Email["✉️ Resend / Cloudflare Email<br/>(Transactional Receipts)"]
    end

    %% Client Interactions
    Shopper -->|HTTPS GET/POST| EdgeRouting
    Merchant -->|HTTPS /admin (Protected)| EdgeRouting
    AgentBuyer -->|REST API /api/products, /api/checkout| EdgeRouting
    AgentBuyer -->|JSON-RPC / SSE| MCPWorker
    AgentOp -->|JSON-RPC + Bearer Token| MCPWorker

    %% Edge Routing to Worker
    EdgeRouting --> AstroApp

    %% Workers to Data Layer
    AstroApp -->|D1 Binding (Queries & Tx)| D1
    AstroApp -->|R2 Binding (Images & Files)| R2
    MCPWorker -->|D1 Binding (Direct SQL)| D1
    MCPWorker -->|R2 Binding| R2

    %% Astro App to External Services
    AstroApp -->|Redirect / Webhooks| Stripe
    AstroApp -->|Invoices / Poll| Lightning
    AstroApp -->|Send Notifications| Telegram
    AstroApp -->|Send Confirmation| Email
```

---

## 4. Modular Hexagonal Architecture (Ports & Adapters)

Mã nguồn được tổ chức theo kiến trúc Hexagonal (Ports & Adapters) bên trong `src/features/`. Core business logic hoàn toàn độc lập với SDK của các nhà cung cấp bên ngoài:

```mermaid
flowchart LR
    subgraph DrivingAdapters[" 📥 Driving Adapters (Inbound) "]
        UI["Astro Pages<br/>(SSR HTML Forms)"]
        AdminUI["Admin Dashboard<br/>(shadcn / React)"]
        RestAPI["Public REST API<br/>(/api/products, /api/checkout)"]
        MCP["MCP Tools<br/>(Buyer & Operator)"]
        Webhooks["Webhook Handlers<br/>(/api/webhook/*)"]
    end

    subgraph DomainCore[" 🛡️ Core Business Domain (Vertical Slices) "]
        Products["📦 Products & Inventory"]
        Orders["🧾 Orders & Reservations"]
        Cart["🛒 Cart & Checkout Engine"]
        Media["🖼️ Media Manager"]
        Pages["📑 Markdown Pages"]
        Auth["🔑 Auth & Session Guard"]
        Secrets["🔐 Secret Vault (AES-GCM)"]
    end

    subgraph Ports[" 🔌 Ports (Abstract Interfaces) "]
        P_Pay["PaymentProvider"]
        P_Store["StorageProvider"]
        P_Mail["EmailProvider"]
        P_Ship["ShippingCalculator"]
        P_Notify["NotificationService"]
    end

    subgraph DrivenAdapters[" 📤 Driven Adapters (Outbound) "]
        A_Stripe["StripeAdapter"]
        A_LN["LightningAdapter<br/>(phoenixd/LNbits)"]
        A_OpenNode["OpenNodeAdapter"]
        A_Manual["COD / BankAdapter"]
        A_R2["CloudflareR2Adapter"]
        A_Resend["ResendAdapter"]
        A_Telegram["TelegramBotAdapter"]
        A_D1["D1DatabaseClient & FTS5"]
    end

    DrivingAdapters --> DomainCore
    DomainCore --> Ports
    
    P_Pay -.-> A_Stripe
    P_Pay -.-> A_LN
    P_Pay -.-> A_OpenNode
    P_Pay -.-> A_Manual
    P_Store -.-> A_R2
    P_Mail -.-> A_Resend
    P_Notify -.-> A_Telegram
    DomainCore --> A_D1
```

---

## 5. Order, Payment & Settlement Lifecycle

Quy trình xử lý đơn hàng từ lúc đặt hàng đến khi tất toán và gửi thông báo, bảo đảm tính bất biến **Paid-Only Invariant** (bảng `orders` chỉ chứa các đơn hàng đã thanh toán thành công):

```mermaid
sequenceDiagram
    autonumber
    actor User as 👤 Shopper / AI Agent
    participant Web as ⚡ Storefront / API
    participant CartRes as 🔒 Stock Reservation
    participant Pending as ⏳ Pending Payments (D1)
    participant Rail as 💳 Payment Rail (Stripe / LN / Bank)
    participant Claim as 🛡️ Settlement Claim
    participant OrderDB as 🧾 Orders Table (D1)
    participant Notify as 🔔 Telegram & Email

    User->>Web: Khởi tạo thanh toán (Initiate Checkout)
    Web->>CartRes: Tạo giữ chỗ kho hàng (Atomic Stock Hold)
    Web->>Pending: Ghi nhận bản ghi `pending_payments`
    Web->>Rail: Tạo Session / Sinh Invoice (Stripe / Lightning BOLT11 / QR)
    Rail-->>User: Hiển thị trang thanh toán / QR Code

    alt Thanh toán trực tuyến (Stripe Webhook / Lightning Polling)
        Rail->>Web: Webhook Event hoặc Polling xác nhận thanh toán
        Web->>Claim: Yêu cầu xác lập tất toán độc quyền (Atomic Settlement Claim)
        Claim->>OrderDB: Chuyển dữ liệu vào bảng `orders` (Paid-Only)
        Claim->>CartRes: Chốt giảm số lượng tồn kho vĩnh viễn (Commit Stock)
        Claim->>Pending: Đánh dấu `settled`
        Web->>Notify: Bắn thông báo Telegram (Group/Topic) & Gửi Email biên lai
    else Thanh toán COD / Chuyển khoản ngân hàng (Manual)
        Web->>OrderDB: Tạo đơn hàng `manual_pending`
        User-->>Web: Xác nhận hoàn tất đặt hàng
        Web->>Notify: Báo đơn mới về Telegram để Merchant xử lý
    else Hết hạn / Huỷ thanh toán
        Pending->>CartRes: Giải phóng giữ chỗ kho (Release Stock Hold)
    end
```

---

## 6. Dual-Layer Configuration & Secret Vault

Hệ thống kết hợp 2 tầng cấu hình để đảm bảo an toàn, bảo mật và linh hoạt khi triển khai:

```mermaid
flowchart TD
    subgraph Layer1[" 🛠️ Layer 1: Static Compile-Time Defaults "]
        ConfigTS["<code>src/config.ts</code><br/>Upstream defaults & schema"]
        StoreConfig["<code>src/store.config.ts</code><br/>Store branding & feature flags"]
        ThemeConfig["<code>theme.config.json</code><br/>Active theme selection"]
    end

    subgraph Layer2[" 🗄️ Layer 2: Dynamic Runtime Settings (D1) "]
        D1Settings["Bảng <code>settings</code> trong D1<br/>- Tên cửa hàng, địa chỉ, currency<br/>- Bật/tắt phương thức thanh toán<br/>- Cấu hình Telegram Chat ID / Topic"]
        SecretVault["🔐 Encrypted Secret Vault<br/>- Stripe Secret Key & Webhook Secret<br/>- Lightning Node Passwords & Tokens<br/>- Resend API Key & Turnstile Secret<br/><i>Mã hóa bằng WebCrypto AES-256-GCM qua SECRETS_KEK</i>"]
    end

    subgraph RuntimeResolver[" ⚙️ Runtime Config Resolver <code>getConfig()</code> "]
        MergedConfig["Cấu hình hợp nhất cuối cùng (Merged Config)<br/>Layer 2 ghi đè Layer 1 theo thời gian thực<br/>Secrets chỉ giải mã trong Worker, ghi 1 chiều (Write-Only) từ UI"]
    end

    Layer1 --> MergedConfig
    Layer2 --> MergedConfig
```

---

## 7. AI Agent & Human Dual Interface

Hệ thống hỗ trợ song song 2 đối tượng người dùng qua 2 kiến trúc tối ưu riêng biệt:

```mermaid
flowchart LR
    subgraph HumanChannel[" 👤 Human Shopper Channel "]
        H_Req["Browser Navigation"] --> H_Astro["Astro SSR Pages"]
        H_Astro --> H_HTML["HTML-First + CSS Tokens"]
        H_HTML --> H_Enhance["Progressive Enhancement<br/>(Live Search, Cart Drawer, QR Poll)"]
    end

    subgraph AgentChannel[" 🤖 AI Agent Commerce Channel "]
        A_REST["REST API Client"] --> A_Routes["/api/products, /api/checkout"]
        A_MCP["MCP Client (Claude/Cursor)"] --> A_Worker["Standalone MCP Worker (mcp/)"]
        A_Worker --> A_Tools["Buyer Tools (Search, Checkout, Order Status)<br/>Operator Tools (Catalog CRUD, Fulfill, Refunds)"]
    end

    subgraph SharedCore[" 🗄️ Shared D1 Database & R2 Storage "]
        D1Core[("Cloudflare D1 Database")]
        R2Core[("Cloudflare R2 Bucket")]
    end

    H_Astro --> SharedCore
    A_Routes --> SharedCore
    A_Worker --> SharedCore
```

---

## 8. Database Architecture & Entity Relationship Diagram (ERD)

Sơ đồ cấu trúc thực thể và quan hệ trong cơ sở dữ liệu SQLite (Cloudflare D1):

```mermaid
erDiagram
    CATEGORIES ||--o{ CATEGORIES : "parent_id"
    CATEGORIES ||--o{ PRODUCT_CATEGORIES : "has"
    PRODUCTS ||--o{ PRODUCT_CATEGORIES : "belongs to"
    PRODUCTS ||--o{ PRODUCT_VARIANTS : "has"
    PRODUCTS ||--o{ PRODUCT_EXTRAS : "has"
    PRODUCTS ||--o{ PRODUCT_IMAGES : "has"
    PRODUCT_IMAGES }o--|| MEDIA : "image_key"

    ORDERS ||--|{ ORDER_ITEMS : "contains"
    ORDERS ||--o{ REFUNDS : "has"
    ORDERS ||--o{ SHIPPING_LABELS : "generates"
    ORDERS }o--o| CUSTOMERS : "customer_id"

    PENDING_PAYMENTS ||--o{ CHECKOUT_RESERVATIONS : "holds stock"
    PENDING_PAYMENTS ||--o| ORDERS : "settles to"

    PRODUCTS {
        text id PK "Public ID (prod_...)"
        text title "Tên sản phẩm / sách"
        text slug UK "URL slug"
        text description "Mô tả chi tiết"
        integer price_cents "Giá cơ bản (minor units)"
        integer stock "Số lượng tồn kho"
        text status "active / draft / archived"
        text primary_image_key "Khóa ảnh chính"
        integer weight_grams "Khối lượng sách"
        text delivery_method "physical / digital"
    }

    PRODUCT_VARIANTS {
        text id PK "Public ID (var_...)"
        text product_id FK
        text title "Bìa cứng / Bìa mềm"
        integer price_cents
        integer stock
        text image_key
    }

    CATEGORIES {
        text id PK "Public ID (cat_...)"
        text name "Tên danh mục"
        text slug UK
        text parent_id FK
        integer sort_order
    }

    ORDERS {
        text id PK "Public ID (ord_...)"
        text order_number UK "Mã đơn hàng (VD: #1001)"
        text customer_email
        text customer_name
        text shipping_address
        integer total_cents "Tổng tiền (minor units)"
        integer subtotal_cents
        integer shipping_cents
        integer tax_cents
        text payment_method "stripe / lightning / cod / bank"
        text payment_status "paid / pending"
        text fulfillment_status "unfulfilled / fulfilled / refunded"
        text public_token UK "Token tra cứu bảo mật"
        datetime created_at
    }

    ORDER_ITEMS {
        text id PK
        text order_id FK
        text product_id FK
        text variant_id FK
        text title
        integer quantity
        integer unit_price_cents
        integer total_cents
    }

    PENDING_PAYMENTS {
        text id PK "Public ID (pay_...)"
        text provider "stripe / lightning / opennode"
        text provider_session_id
        integer amount_cents
        text status "pending / settled / expired"
        datetime expires_at
        text metadata_json
    }

    CHECKOUT_RESERVATIONS {
        text id PK
        text pending_payment_id FK
        text product_id FK
        text variant_id FK
        integer quantity
        datetime expires_at
    }

    CUSTOMERS {
        text id PK "Public ID (cus_...)"
        text email UK
        text name
        text phone
        text default_shipping_address
    }

    MEDIA {
        text key PK "R2 Object Key"
        text filename
        text mime_type
        integer size_bytes
        integer width
        integer height
        integer reference_count "Số lượng liên kết"
    }

    SETTINGS {
        text key PK "Tên cấu hình"
        text value "Giá trị cấu hình (plain hoặc encrypted)"
        integer is_secret "1 nếu mã hóa AES-GCM"
    }

    PAGES {
        text id PK "Public ID (page_...)"
        text slug UK
        text title
        text content_markdown
        text layout_preset "default / wide / minimal"
        text status "published / draft"
    }
```

---

## 9. Directory Layout & Feature Slices

Toàn bộ mã nguồn áp dụng mô hình phân chia theo tính năng (**Vertical Feature Slices**), giúp mỗi module tự đóng gói query, kiểu dữ liệu và UI:

```
src/
├── config.ts              # Upstream config schema, defaults & types
├── store.config.ts        # Customization overrides (branding, links)
├── middleware.ts          # Fail-closed authentication & bot protection gate
├── env.d.ts               # Cloudflare Bindings (D1, R2, SECRETS_KEK)
├── layouts/               # Layout.astro (Storefront), AdminLayout.astro
├── pages/                 # Astro Route Handlers (SSR)
│   ├── index.astro        # Trang chủ cửa hàng
│   ├── products/          # Chi tiết sản phẩm & tìm kiếm
│   ├── categories/        # Trang danh mục sách
│   ├── cart.astro         # Giỏ hàng
│   ├── checkout.astro     # Trang đặt hàng & thanh toán
│   ├── pay/               # Trang hiển thị Lightning invoice & QR polling
│   ├── order/             # Trang xác nhận đơn & tải file kỹ thuật số
│   ├── pages/             # Hiển thị Markdown pages
│   ├── admin/             # Dashboard quản trị (shadcn/ui + React)
│   ├── api/               # REST APIs & Webhooks
│   └── images/            # R2 private image proxy
└── features/              # Feature Vertical Slices
    ├── auth/              # PBKDF2 hashing, session cookies, Turnstile
    ├── cart/              # HttpOnly cookie-based cart state
    ├── catalog/           # Public JSON serialization cho Agent
    ├── categories/        # Danh mục phân cấp
    ├── customers/         # Quản lý khách hàng & địa chỉ
    ├── digitalDelivery/   # Tệp số & secure download tokens
    ├── email/             # EmailProvider (Resend / CF Email)
    ├── media/             # Quản lý tệp R2 & reference counting
    ├── navigation/        # Menu điều hướng động
    ├── orders/            # Đơn hàng, atomic stock reservation & settlement
    ├── pages/             # Quản trị trang Markdown tĩnh
    ├── payments/          # PaymentProvider & adapters (Stripe, LN, OpenNode, COD, Bank)
    ├── products/          # Quản lý sản phẩm, variants, extras, FTS5 search
    ├── refunds/           # Xử lý hoàn tiền
    ├── search/            # D1 FTS5 full-text search
    ├── secrets/           # AES-256-GCM Secret Vault
    ├── settings/          # Cấu hình runtime D1
    ├── shipping/          # Tính phí vận chuyển & in vận đơn
    ├── storage/           # StorageProvider & R2 Adapter
    ├── storefront/        # Theme tokens & Layout contracts
    └── telegram/          # Telegram Bot API client & alerts
```

---

## 10. Architectural Invariants (Quy tắc bất biến)

1. **Near-Zero Client JS:** Giao diện Storefront hoàn toàn render từ Server (SSR), không tải các framework JS nặng nề ở client. Sử dụng form chuẩn HTML và Web components / Progressive Enhancement khi cần tương tác.
2. **Paid-Only Orders Invariant:** Bảng `orders` **chỉ** lưu trữ các giao dịch đã thanh toán hoặc đã xác nhận thành công. Các thanh toán đang chờ xử lý được giữ trong `pending_payments`.
3. **Dual-Layer Configuration:** Thiết lập runtime vận hành nằm trong D1 (`settings`), còn cấu hình tĩnh và giá trị mặc định nằm trong `config.ts` / `store.config.ts`.
4. **Ports & Adapters Core:** Toàn bộ logic lõi chỉ phụ thuộc vào Interface trừu tượng (`PaymentProvider`, `StorageProvider`, `EmailProvider`).
5. **Fail-Closed Admin:** Khi chạy production, nếu thiếu cấu hình hoặc credentials, hệ thống sẽ tự động khóa `/admin` thay vì mở công khai.
6. **Additive Migrations Only:** Các file migration trong `migrations/` luôn tuân thủ nguyên tắc tăng dần (`CREATE TABLE IF NOT EXISTS`, `ALTER TABLE ADD COLUMN`) và không bao giờ sửa đổi file migration cũ đã chạy.
7. **Minor Units for Money:** Toàn bộ giá tiền, thuế, phí vận chuyển được lưu trữ và tính toán bằng đơn vị nhỏ nhất (cents, satoshis, VND) dưới dạng số nguyên (`integer`) để loại bỏ sai số dấu phẩy động.
8. **Media Single Ownership:** Toàn bộ thao tác tải lên, xóa và quản lý tệp trên Cloudflare R2 được quản lý tập trung thông qua `features/media`. Các thực thể khác chỉ lưu trữ `image_key`.
