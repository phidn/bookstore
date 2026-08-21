-- 0040: replace the initial technical-demo copy with store-owned Vietnamese
-- content. The body guards deliberately match only the shipped demo opening,
-- so a merchant-edited page is never overwritten by this migration.

UPDATE pages
SET title = 'Về Tiểu Viện Hữu Thư',
    updated_at = datetime('now')
WHERE slug = 'about'
  AND title = 'Về Chúng Tôi (About Bookstore)';

UPDATE pages
SET body_markdown = 'Tiểu Viện Hữu Thư là một tiệm sách cũ nhỏ tại TP. Hồ Chí Minh — nơi sách được tìm lại, đọc tiếp và trở thành khởi đầu cho những cuộc trò chuyện mới.

## Ở tiểu viện có gì?

- Sách cũ được tuyển chọn và kiểm tra trước khi lên kệ.
- Tình trạng từng cuốn được mô tả rõ ràng để bạn dễ lựa chọn.
- Những câu chuyện, ghi chú và cuộc trò chuyện xoay quanh sách.

Chúng tôi tin rằng một cuốn sách đã qua tay người đọc không hề mất đi giá trị. Nó chỉ đang chờ gặp người tiếp theo.

## Kết nối với tiểu viện

Bạn có thể tìm **@tieuvienhuuthu** trên Facebook, Instagram, TikTok và Threads.

*Một tiểu viện nhỏ có nhiều chuyện để nói với nhau nghe.*',
    updated_at = datetime('now')
WHERE slug = 'about'
  AND body_markdown LIKE '# Chào mừng đến với Bookstore Demo%';

UPDATE pages
SET title = 'Chính sách giao hàng và đổi trả',
    updated_at = datetime('now')
WHERE slug = 'shipping-policy'
  AND title = 'Chính Sách Vận Chuyển & Đổi Trả';

UPDATE pages
SET body_markdown = 'Mỗi cuốn sách cũ thường chỉ có một bản. Tiểu Viện Hữu Thư kiểm tra, mô tả tình trạng và đóng gói từng cuốn trước khi gửi đi.

## Khu vực giao hàng

Website hiện nhận đơn giao trong nội thành TP. Hồ Chí Minh. Phí giao hàng và thời gian dự kiến được hiển thị hoặc xác nhận trước khi hoàn tất đơn.

Nếu bạn ở ngoài TP. Hồ Chí Minh, vui lòng liên hệ **@tieuvienhuuthu** trước khi đặt để tiểu viện kiểm tra phương án vận chuyển phù hợp.

## Tình trạng sách

Sách cũ có thể có dấu vết thời gian như ố nhẹ, ghi chú hoặc hao mòn ở bìa. Những đặc điểm đáng chú ý sẽ được thể hiện trong hình ảnh hoặc phần mô tả sản phẩm. Vui lòng đọc kỹ trước khi đặt.

## Khi đơn hàng có vấn đề

Nếu bạn nhận sai sách, sách khác đáng kể so với mô tả hoặc bị hư hại trong quá trình vận chuyển, hãy liên hệ tiểu viện sớm nhất có thể và gửi kèm hình ảnh. Tiểu viện sẽ kiểm tra và thống nhất phương án đổi, trả hoặc hoàn tiền phù hợp với tình trạng thực tế.

## Liên hệ

Facebook, Instagram, TikTok và Threads: **@tieuvienhuuthu**',
    updated_at = datetime('now')
WHERE slug = 'shipping-policy'
  AND body_markdown LIKE '# Chính Sách Giao Hàng & Đổi Trả (Demo)%';
