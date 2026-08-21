# Project Memory & Active State

## 1. Current Snapshot
- **Trạng thái hiện tại:** Nền tảng thương mại điện tử Astro SSR trên Cloudflare Workers + D1 + R2 tích hợp Agent API & MCP; Hệ thống tài liệu đã được chuẩn hóa theo mô hình Flat LLM-Wiki & Lean Memory.
- **Mục tiêu ưu tiên:** Sẵn sàng cho việc tùy biến giao diện, cấu hình storefront, tích hợp cổng thanh toán và mở rộng các luồng agent autonomous shopping/operating.

## 2. Active Focus
- [x] Hoàn thành gần nhất:
  - Tạo và tích hợp bộ logo Tiểu Viện Hữu Thư từ mô-típ logo footer: biểu trưng mái viện + hàng cột + sách mở; có SVG/PNG light và dark, lockup tên đầy đủ, avatar 1024px, favicon, Apple Touch Icon, icon 192/512 và bảng preview tại `public/brand/`. Header, footer và sidebar Admin đã dùng cùng hệ thống logo; hướng dẫn nằm tại `docs/wiki/brand-logo-assets.md`.
  - Khắc phục lỗi APFS khiến thư mục `public/` không thể liệt kê/tạo file (`Invalid argument`): giữ nguyên thư mục lỗi để phục hồi tại `/Volumes/Lexar_E6/davis/projects/tieuvienhuuthu/bookstore-public-recovery-20260821-1824`, dựng lại toàn bộ asset tracked từ Git rồi mới thêm bộ logo.
  - Chuẩn hóa các trang được footer dẫn tới: Việt hóa catalog, tìm kiếm, giỏ sách/drawer, sắp xếp và phân trang; thay nội dung demo bằng `Về Tiểu Viện Hữu Thư` và `Chính sách giao hàng và đổi trả` qua migration cộng dồn `0040`, chỉ cập nhật khi dữ liệu vẫn là bản demo cũ.
  - Triển khai homepage Tiểu Viện Hữu Thư: header/nav full-width kiểu bookstore với search icon + submit button, giỏ sách có icon, menu cân giữa; hero slider 3 nội dung điều khiển ngang không làm trang nhảy; section `Sách tuyển chọn` lấy dữ liệu D1; footer sitemap lớn theo nhận diện Mocha Mousse có Facebook, Instagram, TikTok và Threads cùng handle `tieuvienhuuthu`; mở catalog `Tất cả sách` cùng trục 96rem với header và grid 5 cột desktop.
  - Khởi tạo GitHub Issues & Project Board (#1); Cập nhật Task 1 (Mocha Mousse), Task 2 (Homepage), Task 3 (Demo/Staging data).
  - Vẽ lại toàn bộ sơ đồ kiến trúc hệ thống (Mermaid diagrams: Edge Topology, Ports & Adapters, Order/Settlement Sequence, Dual-Layer Config, Agent Commerce, Database ERD) vào [system-overview.md](docs/wiki/system-overview.md).
  - Issue #3: [Task 1: Tạo Theme Brand Mocha Mousse cho Bookstore (Tiểu Viện Hữu Thư)](https://github.com/phidn/bookstore/issues/3)
  - Issue #4: [Task 2: Tạo Homepage cho Bookstore (Trang chủ Tiểu Viện Hữu Thư)](https://github.com/phidn/bookstore/issues/4)
  - Issue #5: [Task 3: Tạo trang Demo / Staging cho Bookstore lấy dữ liệu example từ tieuvienhuuthu.store](https://github.com/phidn/bookstore/issues/5)
- [/] Đang thực hiện: Hoàn thiện dữ liệu thật và nội dung navigation cho homepage; chuẩn bị Task 3 (Demo/Staging Data).
- [ ] Việc tiếp theo: Thu thập dữ liệu mẫu từ tieuvienhuuthu.store để tạo seed D1; cấu hình các link Giới thiệu/chính sách trong Admin → Navigation.

## 3. Quick Navigation
- Tri thức & Hướng dẫn: `docs/wiki/INDEX.md`
- Quyết định kiến trúc & Nghiệp vụ: `docs/adr/INDEX.md`
- Issue Tracker: https://github.com/phidn/bookstore/issues
- Project Board (Kanban): https://github.com/users/phidn/projects/1
