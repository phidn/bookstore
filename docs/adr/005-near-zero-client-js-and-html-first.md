# ADR 005: Near-Zero Client JavaScript and Progressive Enhancement

## Trạng thái (Status)
**Accepted**

## Bối cảnh (Context)
Các trang web bán hàng hiện đại thường bị quá tải bởi các thư viện frontend nặng nề, làm chậm tốc độ tải trang, giảm điểm SEO/Core Web Vitals và tăng nguy cơ lỗi trên các thiết bị cấu hình yếu.

## Quyết định (Decision)
1. **HTML-First & SSR:** Toàn bộ giao diện storefront (danh mục sản phẩm, chi tiết sản phẩm, giỏ hàng, checkout) được render hoàn toàn từ server.
2. **Progressive Enhancement:** Các chức năng tương tác (ngăn kéo giỏ hàng Drawer, thanh tìm kiếm FTS live, polling trạng thái hóa đơn thanh toán) được tăng cường bằng Vanilla JS siêu nhẹ.
3. Mọi tính năng cốt lõi bắt buộc phải có plain HTML form fallback để hoạt động trơn tru ngay cả khi JavaScript bị tắt hoặc chưa tải xong.

## Hệ quả (Consequences)
- Tốc độ hiển thị trang cực nhanh, tối đa hóa chỉ số LCP/CLS/FID.
- Trải nghiệm mượt mà, ổn định và thân thiện với SEO / Web Crawlers.
