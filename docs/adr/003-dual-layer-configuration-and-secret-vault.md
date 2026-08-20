# ADR 003: Dual-Layer Configuration and Encrypted Secret Vault

## Trạng thái (Status)
**Accepted**

## Bối cảnh (Context)
Các thiết lập của cửa hàng có hai tính chất khác nhau:
1. Thiết lập vận hành nghiệp vụ (tên shop, múi giờ, cấu hình thanh toán, email) cần cập nhật ngay lập tức mà không cần build/deploy lại code.
2. Thiết lập kỹ thuật & phiên bản (đơn vị tiền tệ, dải phí vận chuyển, kích thước ảnh) cần gắn liền với mã nguồn.
Ngoài ra, các API key thanh toán của merchant không nên lưu dạng biến môi trường plain-text trong repo hay env files.

## Quyết định (Decision)
1. **2 tầng cấu hình:**
   - **Tầng 1 (Runtime, D1):** Bảng `settings` trong D1 quản lý qua Admin UI.
   - **Tầng 2 (Build-Time, Code):** `src/config.ts` (mặc định) và `src/store.config.ts` (override cho từng store).
2. **Secret Vault trong D1:** Mọi secret nhạy cảm (Stripe keys, Lightning passwords) được mã hóa đối xứng AES-GCM bằng Key Encryption Key (`SECRETS_KEK`) trước khi ghi vào D1, và là write-only trên giao diện admin.

## Hệ quả (Consequences)
- Đảm bảo an toàn tuyệt đối cho thông tin thanh toán của khách hàng & merchant.
- Phân định rõ ràng giữa cấu hình tĩnh (versioned) và cấu hình động (operational).
