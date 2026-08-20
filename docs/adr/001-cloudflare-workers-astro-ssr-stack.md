# ADR 001: Cloudflare Workers & Astro SSR Stack

## Trạng thái (Status)
**Accepted**

## Bối cảnh (Context)
Dự án e-commerce cần một nền tảng vận hành với chi phí khởi đầu gần như $0 (free-tier friendly), độ trễ cực thấp trên toàn cầu (edge rendering), không cần quản trị server/container phức tạp, đồng thời hỗ trợ cả server-rendered HTML cho người dùng lẫn JSON API cho AI agents.

## Quyết định (Decision)
1. Sử dụng **Astro (SSR mode)** kết hợp adapter `@astrojs/cloudflare` chạy trên **Cloudflare Workers**.
2. Sử dụng **Cloudflare D1** (SQLite phân tán) làm cơ sở dữ liệu chính.
3. Sử dụng **Cloudflare R2** để lưu trữ hình ảnh và tệp tải về (zero egress fee).
4. Sử dụng **Tailwind CSS v4** cho styling với hệ thống theme tokens dạng CSS variables.

## Hệ quả (Consequences)
- **Ưu điểm:** Khởi động cực nhanh (sub-millisecond cold starts), chi phí duy trì thấp, kiến trúc phi máy chủ hoàn toàn.
- **Nhược điểm & Ràng buộc:** Phải tuân thủ môi trường runtime V8 isolates của Cloudflare Workers (không dùng Node native binaries; các thư viện phải tương thích Web Standard API / Web Crypto).
