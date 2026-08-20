# ADR 004: Agent-First Architecture (Public REST API & Dedicated MCP Worker)

## Trạng thái (Status)
**Accepted**

## Bối cảnh (Context)
Thương mại điện tử đang dịch chuyển sang hướng hỗ trợ AI Agents tự động mua sắm và các chủ shop dùng AI để vận hành catalog/đơn hàng. Cần cung cấp giao diện chuẩn hóa mà không làm ảnh hưởng đến hiệu năng hay bảo mật của web storefront.

## Quyết định (Decision)
1. **Public Agent REST API:** Cung cấp `/api/products` và `/api/checkout` trả về định dạng JSON chuẩn với CORS mở, cho phép agent duyệt danh mục và tạo phiên thanh toán (Lightning BOLT11 / Stripe URL) không cần browser.
2. **Dedicated MCP Worker:** Đặt server Model Context Protocol trong thư mục riêng `mcp/` chạy như 1 Cloudflare Worker độc lập cùng trỏ vào D1:
   - *Buyer Tier:* Công khai, rate-limited để agent tra cứu & tạo checkout.
   - *Operator Tier:* Yêu cầu Bearer token (`MCP_TOKEN`) để thực hiện các thao tác quản trị catalog và đơn hàng.
3. Giữ các dependency của `@modelcontextprotocol/sdk` và `agents` cách ly hoàn toàn trong `mcp/package.json`.

## Hệ quả (Consequences)
- Storefront chính không bị phình to kích thước bundle hay xung đột build với Cloudflare Vite plugin.
- Agent có thể tương tác đầy đủ với cửa hàng theo cả 2 phương thức REST và MCP.
