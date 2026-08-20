# CLAUDE.md — Single Source of Truth for bookstore

Hệ thống tài liệu và quy chuẩn phát triển dành cho AI Assistants (Claude Code, Antigravity, Codex) và cộng tác viên dự án **bookstore**.

---

## 1. Nguyên tắc Hệ thống Tài liệu (Flat LLM-Wiki & Lean Memory)

1. **Bộ nhớ hoạt động (Active State):**
   - File `memory.md` tại root lưu trữ snapshot hiện tại, task vừa hoàn thành, task đang làm và backlog ưu tiên.
   - **Bắt buộc:** Tự động cập nhật `memory.md` sau mỗi phiên làm việc có thay đổi trạng thái hoặc hoàn thành task.
2. **Hồ sơ quyết định kiến trúc (ADR):**
   - Thư mục `docs/adr/` lưu trữ các quyết định kiến trúc đánh số dạng `001-xxx.md`.
   - Tra cứu và cập nhật trạng thái tại `docs/adr/INDEX.md`.
3. **Tri thức phẳng (Flat Wiki):**
   - Mọi tài liệu kỹ thuật, sản phẩm, hướng dẫn lưu phẳng tại `docs/wiki/` theo chuẩn `kebab-case.md` (**TUYỆT ĐỐI KHÔNG TẠO THƯ MỤC CON / NO SUBFOLDERS**).
   - Bắt đầu tra cứu tri thức từ trang chỉ mục `docs/wiki/INDEX.md`.

---

## 2. Vòng lặp phát triển (The Loop)

```sh
nvm use 22         # BẮT BUỘC — Toolchain chạy trên Node 22 (≥ 22.12)
npm run verify     # Cổng kiểm thử toàn diện: Unit tests + Astro check + Build + D1 integration + MCP check
```

- **`npm run verify`** là thước đo chuẩn xác duy nhất: Chạy lệnh này sau mỗi lần chỉnh sửa có ý nghĩa trước khi commit/kết thúc task.
- `npm run dev`: Astro development server (`http://localhost:4321`).
- `npm run preview`: Wrangler dev (Production mode, dùng để test middleware, auth và sessions).
- `npm test`: Chạy unit test qua Vitest.
- `npm run db:migrate`: Chạy migration D1 trên môi trường local.

### Kiểm tra dữ liệu local bằng Local Explorer
Dev server hỗ trợ Cloudflare Local Explorer tại `http://localhost:4321/cdn-cgi/explorer` (UI) và `/cdn-cgi/explorer/api` (REST API). Ưu tiên dùng API này thay vì gọi CLI `npx wrangler d1 execute` để tăng tốc độ truy vấn (~70x nhanh hơn).

---

## 3. Quy chuẩn Kiến trúc & Bất biến (Architectural Invariants)

1. **Storefront Near-Zero Client JS:** Server-render toàn bộ giao diện; JavaScript chỉ dùng để tăng cường (progressive enhancement cho cart drawer, invoice polling, turnstile).
2. **Orders Table là Paid-Only:** Chỉ ghi đơn hàng đã thanh toán thành công vào bảng `orders`. Giao dịch đang chờ lưu tại `pending_payments`.
3. **Cấu hình 2 tầng:** Cấu hình vận hành lưu tại D1 (`settings` table); cấu hình build-time lưu tại `src/config.ts` và override trong `src/store.config.ts`.
4. **Ports & Adapters:** Tuyệt đối không import trực tiếp vendor SDK vào controller/checkout; chỉ tương tác qua các interface (`PaymentProvider`, `StorageProvider`, `EmailProvider`, `SearchProvider`).
5. **Admin Fail-Closed:** Khi chưa cấu hình mật khẩu hoặc thiếu biến môi trường, Admin phải khóa hoàn toàn (fail-closed), không tạo backdoor hay bypass.
6. **Migrations mang tính cộng dồn (Additive):** Các file trong `migrations/` chỉ được thêm mới, không chỉnh sửa migration cũ đã chạy.
7. **Tiền tệ dùng Minor Units (Integer):** Toàn bộ số tiền xử lý dưới dạng integer cents/satoshis; chỉ format ở tầng hiển thị bằng `formatPrice()`.
8. **Độc quyền sở hữu Media:** Tệp tải lên R2 do `features/media` quản lý duy nhất; xóa liên kết ở sản phẩm chỉ giảm reference count, không xóa file R2 trực tiếp nếu còn thực thể khác dùng.
9. **Bảo mật Markdown:** Trang nội dung người dùng render bằng server markdown với `html: false` để chống XSS.
10. **MCP Worker cách ly:** Mã nguồn MCP server nằm trong `mcp/` với `package.json` riêng biệt. Không cài đặt `@modelcontextprotocol/sdk` vào root `package.json`.

---

## 4. Đồng bộ giữa các AI CLI

- **Single Source of Truth (SSOT):** `CLAUDE.md` tại root.
- `GEMINI.md` (Antigravity CLI) -> symlink hoặc trỏ về `CLAUDE.md`.
- `AGENTS.md` (Codex / Agent tooling) -> symlink hoặc trỏ về `CLAUDE.md`.
- `CODEX.md` (Codex CLI) -> symlink hoặc trỏ về `CLAUDE.md`.
