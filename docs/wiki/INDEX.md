# Documentation Wiki — Master Index

Chào mừng bạn đến với hệ thống tri thức (Flat LLM-Wiki) của dự án **bookstore**. Toàn bộ tài liệu được lưu trữ dạng phẳng trong thư mục `docs/wiki/` dưới dạng file `kebab-case.md`.

---

## 📚 Mục lục tài liệu (Wiki Index)

### 1. Kiến trúc & Tổng quan (Core Architecture)
- [System Overview & Architecture](system-overview.md): Tổng quan kiến trúc hệ thống, stack công nghệ, feature vertical slices, và các invariants cốt lõi.
- [Security Policy & Architecture](security-policy.md): Chính sách bảo mật, mã hóa Secret Vault (AES-GCM), Web Crypto, và cơ chế fail-closed admin.

### 2. Phát triển & Vận hành (Engineering & Ops)
- [Development Guide & Workflow](development-guide.md): Hướng dẫn cài đặt local, công cụ Local Explorer, chu trình kiểm thử `npm run verify` và các quy ước code.
- [Deployment & Provisioning](deployment-and-provisioning.md): Quy trình khởi tạo hạ tầng Cloudflare D1/R2, chạy migrations và deploy production.

### 3. Tính năng & Giao diện (Storefront & Features)
- [Storefront Customization Guide](storefront-customization.md): Thang tùy biến (Customization ladder), theme tokens, hợp đồng ProductCard / Header, và Markdown pages.
- [Payments & Settlements](payments-and-settlements.md): Cơ chế thanh toán đa kênh (Stripe, Lightning phoenixd/lnbits, OpenNode, Demo), xử lý polling và settlement.

### 4. Agent & Tích hợp (AI Agent & Autonomous Commerce)
- [Agent API & Model Context Protocol (MCP)](agent-api-and-mcp.md): Đặc tả REST API công khai cho AI agents mua hàng và Worker MCP độc lập phục vụ quản trị / shopping tự động.

---

## 🔗 Liên kết liên quan
- **Bộ nhớ hoạt động:** [memory.md](../../memory.md)
- **Hồ sơ quyết định kiến trúc:** [ADR Index](../adr/INDEX.md)
