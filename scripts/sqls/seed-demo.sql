-- seed-demo.sql — Curated Open Source Demo Catalog for Bookstore (24 classic books across 6 categories)
-- Independent from production store. Safe to run repeatedly.

PRAGMA defer_foreign_keys=TRUE;

-- ── 1. Categories ─────────────────────────────────────────────────────────────
INSERT OR IGNORE INTO categories (name, slug) VALUES ('Văn học & Tiểu thuyết', 'van-hoc');
INSERT OR IGNORE INTO categories (name, slug) VALUES ('Triết học & Tư tưởng', 'triet-hoc');
INSERT OR IGNORE INTO categories (name, slug) VALUES ('Khoa học & Vũ trụ', 'khoa-hoc');
INSERT OR IGNORE INTO categories (name, slug) VALUES ('Tâm lý & Kỹ năng', 'tam-ly');
INSERT OR IGNORE INTO categories (name, slug) VALUES ('Kinh doanh & Đầu tư', 'kinh-doanh');
INSERT OR IGNORE INTO categories (name, slug) VALUES ('Lịch sử & Văn hóa', 'lich-su');

-- ── 2. Demo Products ──────────────────────────────────────────────────────────
INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Hoàng Tử Bé (The Little Prince)',
  'hoang-tu-be-the-little-prince',
  'Tác giả: Antoine de Saint-Exupéry\n\nThể loại: Văn học kinh điển thế giới\n\nCuốn sách tuyệt đẹp dành cho những người lớn đã từng là trẻ con. Một hành trình phiêu lưu giữa các vì sao, mang thông điệp bất hủ về tình yêu thương, tình bạn và cách nhìn cuộc sống bằng trái tim.',
  45000,
  'vnd',
  50,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Nhà Giả Kim (The Alchemist)',
  'nha-gia-kim-the-alchemist',
  'Tác giả: Paulo Coelho\n\nThể loại: Tiểu thuyết triết lý\n\nCâu chuyện huyền thoại về chàng chăn cừu Santiago trên con đường theo đuổi Vận Mệnh của đời mình. Cuốn sách thúc đẩy hàng triệu độc giả dám ước mơ và lắng nghe tiếng gọi từ trái tim.',
  58000,
  'vnd',
  80,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Sapiens: Lược Sử Loài Người',
  'sapiens-luoc-su-loai-nguoi',
  'Tác giả: Yuval Noah Harari\n\nThể loại: Lịch sử & Khoa học nhân loại\n\nKiệt tác đồ sộ tái hiện toàn bộ tiến trình tiến hóa của loài người từ một sinh vật tầm thường tại Đông Phi trở thành kẻ thống trị hành tinh thông qua các cuộc cách mạng nhận thức, nông nghiệp và khoa học.',
  165000,
  'vnd',
  40,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Lược Sử Thời Gian (A Brief History of Time)',
  'luoc-su-thoi-gian-a-brief-history-of-time',
  'Tác giả: Stephen Hawking\n\nThể loại: Khoa học vũ trụ & Vật lý thiên văn\n\nCánh cửa mở ra những bí ẩn lớn nhất của vũ trụ học: từ vụ nổ Big Bang, lỗ đen bí ẩn đến lý thuyết thống nhất và mũi tên thời gian, được trình bày dễ hiểu cho mọi độc giả yêu khoa học.',
  85000,
  'vnd',
  35,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Tội Ác Và Trừng Phạt (Crime and Punishment)',
  'toi-ac-va-trung-phat',
  'Tác giả: Fyodor Dostoevsky\n\nThể loại: Đại văn học Nga\n\nCuộc đấu tranh nội tâm dữ dội của chàng sinh viên Raskolnikov giữa lý trí ngạo mạn và sự cắn rứt lương tâm. Đỉnh cao của nghệ thuật phân tích tâm lý con người trong văn học thế giới.',
  145000,
  'vnd',
  25,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Chiến Tranh Và Hòa Bình (War and Peace)',
  'chien-tranh-va-hoa-binh',
  'Tác giả: Leo Tolstoy\n\nThể loại: Sử thi kinh điển\n\nBức tranh hoành tráng về xã hội Nga trong thời kỳ bão táp của cuộc chiến tranh chống Napoléon. Sự đan xen tinh tế giữa số phận của những gia tộc quý tộc và những chuyển biến lịch sử vĩ đại.',
  220000,
  'vnd',
  15,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Tâm Lý Học Về Tiền (The Psychology of Money)',
  'tam-ly-hoc-ve-tien',
  'Tác giả: Morgan Housel\n\nThể loại: Tài chính cá nhân & Tư duy thịnh vượng\n\n19 câu chuyện ngắn khai mở góc nhìn sâu sắc về cách con người suy nghĩ về tiền bạc, sự giàu có, lòng tham và hạnh phúc. Thành công tài chính không chỉ là toán học, mà là hành vi.',
  99000,
  'vnd',
  60,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Đắc Nhân Tâm (How to Win Friends and Influence People)',
  'dac-nhan-tam',
  'Tác giả: Dale Carnegie\n\nThể loại: Kỹ năng giao tiếp & Thu phục lòng người\n\nCuốn sách bán chạy nhất mọi thời đại về nghệ thuật đối nhân xử thế, xây dựng mối quan hệ chân thành và thấu hiểu tâm lý con người trong cuộc sống cũng như công việc.',
  65000,
  'vnd',
  100,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Ông Già Và Biển Cả (The Old Man and the Sea)',
  'ong-gia-va-bien-ca',
  'Tác giả: Ernest Hemingway\n\nThể loại: Văn học đạt giải Nobel\n\nKhúc ca bất hủ về lòng dũng cảm, sự kiên định và ý chí bất khuất của con người: "Con người không sinh ra để dành cho thất bại. Con người có thể bị hủy diệt nhưng không thể bị đánh bại."',
  50000,
  'vnd',
  45,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Bắt Trẻ Đồng Xanh (The Catcher in the Rye)',
  'bat-tre-dong-xanh',
  'Tác giả: J.D. Salinger\n\nThể loại: Văn học hiện đại\n\nTiếng nói chân thực và cô đơn của tuổi trẻ trước sự giả tạo của thế giới người lớn qua lời kể của Holden Caulfield. Biểu tượng văn hóa đại chúng của thế hệ trẻ.',
  72000,
  'vnd',
  30,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Vũ Trụ (Cosmos)',
  'vu-tru-cosmos',
  'Tác giả: Carl Sagan\n\nThể loại: Thiên văn học & Triết học khoa học\n\nMột khúc tráng ca bằng văn xuôi về sự hình thành của vũ trụ, hành tinh Trái Đất và nguồn gốc sự sống. Cuốn sách truyền cảm hứng bất tận về vị thế của con người trong không gian bao la.',
  175000,
  'vnd',
  20,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Tôi Tự Học',
  'toi-tu-hoc',
  'Tác giả: Thu Giang Nguyễn Duy Cần\n\nThể loại: Học thuật & Rèn luyện nhân cách\n\nKim chỉ nam cho con đường tự học, mở rộng tri thức và rèn luyện chiều sâu tư duy. Tự học không phải để thi đỗ lấy bằng cấp, mà để mở mang tầm mắt và hoàn thiện nhân cách.',
  49000,
  'vnd',
  50,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Óc Sáng Suốt (Thuật rèn luyện tư duy & suy nghĩ khoa học)',
  'oc-sang-suot',
  'Tác giả: Thu Giang Nguyễn Duy Cần\n\nThể loại: Phương pháp tư duy\n\nChỉ dẫn tường tận cách quan sát tinh tường, phán đoán chính xác và tư duy độc lập trước những thông tin hỗn tạp của cuộc đời.',
  42000,
  'vnd',
  40,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Khắc Kỷ Từ A Đến Z (The Daily Stoic)',
  'khac-ky-tu-a-den-z',
  'Tác giả: Ryan Holiday & Stephen Hanselman\n\nThể loại: Triết học Khắc kỷ ứng dụng\n\n366 ngày chiêm nghiệm minh triết của Seneca, Epictetus và Marcus Aurelius để rèn luyện tâm trí vững vàng, bình thản trước biến cố và làm chủ cảm xúc.',
  135000,
  'vnd',
  35,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Nghệ Thuật Tư Duy Rành Mạch (The Art of Thinking Clearly)',
  'nghe-thuat-tu-duy-ranh-mach',
  'Tác giả: Rolf Dobelli\n\nThể loại: Tâm lý học nhận thức\n\nNhận diện 99 cái bẫy định kiến và sai lầm tư duy thường gặp trong cuộc sống hàng ngày để đưa ra quyết định sáng suốt và chuẩn xác hơn.',
  110000,
  'vnd',
  25,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Trăm Năm Cô Đơn (One Hundred Years of Solitude)',
  'tram-nam-co-don',
  'Tác giả: Gabriel García Márquez\n\nThể loại: Chủ nghĩa hiện thực huyền ảo\n\nLịch sử huyền thoại của dòng họ Buendía và ngôi làng Macondo. Tác phẩm đỉnh cao đoạt giải Nobel văn học, phản ánh nỗi cô đơn truyền kiếp của thân phận con người.',
  155000,
  'vnd',
  18,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Những Người Khốn Khổ (Les Misérables)',
  'nhung-nguoi-khon-kho',
  'Tác giả: Victor Hugo\n\nThể loại: Văn học Pháp kinh điển\n\nBản anh hùng ca về tình người, lòng vị tha và sự cứu rỗi qua cuộc đời đầy thăng trầm của Jean Valjean, Fantine và Cosette giữa bối cảnh Paris nghèo đói và bất công.',
  210000,
  'vnd',
  12,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Cây Cam Ngọt Của Tôi',
  'cay-cam-ngot-cua-toi',
  'Tác giả: José Mauro de Vasconcelos\n\nThể loại: Tiểu thuyết cảm động\n\nCâu chuyện lay động hàng triệu trái tim về cậu bé Zezé với tâm hồn nhạy cảm, giàu trí tưởng tượng và bài học sâu sắc về sự tử tế cũng như nỗi đau trưởng thành.',
  68000,
  'vnd',
  75,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Chuyện Con Mèo Dạy Hải Âu Bay',
  'chuyen-con-meo-day-hai-au-bay',
  'Tác giả: Luis Sepúlveda\n\nThể loại: Văn học thiếu nhi & gia đình\n\nCâu chuyện ấm áp về chú mèo mun Zorba giữ trọn lời hứa chăm sóc và dạy một chú chim hải âu non biết bay. Bài học vô giá về sự khác biệt và tình yêu thương vô điều kiện.',
  40000,
  'vnd',
  90,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Dế Mèn Phiêu Lưu Ký',
  'de-men-phieu-luu-ky',
  'Tác giả: Tô Hoài\n\nThể loại: Văn học Việt Nam kinh điển\n\nTác phẩm bất hủ gắn liền với tuổi thơ bao thế hệ người Việt. Hành trình trải nghiệm thế giới loài vật để học bài học về sự khiêm nhường, tình bạn và khát vọng hòa bình.',
  35000,
  'vnd',
  120,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Số Đỏ',
  'so-do',
  'Tác giả: Vũ Trọng Phụng\n\nThể loại: Văn học hiện thực trào phúng\n\nĐỉnh cao châm biếm sâu cay của văn học Việt Nam đầu thế kỷ 20 qua nhân vật Xuân Tóc Đỏ và bức tranh xã hội tư sản thành thị "Âu hóa" lố lăng, kệch cỡm.',
  52000,
  'vnd',
  40,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Đi Tìm Lẽ Sống (Man''s Search for Meaning)',
  'di-tim-le-song',
  'Tác giả: Viktor E. Frankl\n\nThể loại: Tâm lý học ý nghĩa cuộc sống\n\nTrải nghiệm sinh tồn kiên cường của bác sĩ tâm thần Frankl trong các trại tập trung của Đức Quốc Xã và sự ra đời của liệu pháp ý nghĩa: "Người có một lý do để sống có thể chịu đựng hầu hết mọi nghịch cảnh."',
  78000,
  'vnd',
  55,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Tư Duy Nhanh Và Chậm (Thinking, Fast and Slow)',
  'tu-duy-nhanh-va-cham',
  'Tác giả: Daniel Kahneman\n\nThể loại: Kinh tế học hành vi & Tâm lý học\n\nKhám phá 2 hệ thống chi phối cách con người tư duy: Hệ thống 1 nhanh, trực giác và Hệ thống 2 chậm, lý tính. Công trình đoạt giải Nobel Kinh tế của Daniel Kahneman.',
  180000,
  'vnd',
  0,
  1
);

INSERT OR IGNORE INTO products (name, slug, description, price_cents, currency, stock, active)
VALUES (
  'Từ Tốt Đến Vĩ Đại (Good to Great)',
  'tu-tot-den-vi-dai',
  'Tác giả: Jim Collins\n\nThể loại: Quản trị & Kinh doanh xuất sắc\n\nNghiên cứu công phu về những yếu tố cốt lõi giúp các doanh nghiệp bình thường bứt phá ngoạn mục để trở thành những tổ chức vĩ đại trường tồn cùng thời gian.',
  140000,
  'vnd',
  3,
  1
);

-- ── 3. Product Categories Mapping ─────────────────────────────────────────────
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'hoang-tu-be-the-little-prince' AND c.slug = 'van-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'nha-gia-kim-the-alchemist' AND c.slug = 'van-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'nha-gia-kim-the-alchemist' AND c.slug = 'triet-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'sapiens-luoc-su-loai-nguoi' AND c.slug = 'lich-su';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'sapiens-luoc-su-loai-nguoi' AND c.slug = 'khoa-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'luoc-su-thoi-gian-a-brief-history-of-time' AND c.slug = 'khoa-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'toi-ac-va-trung-phat' AND c.slug = 'van-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'chien-tranh-va-hoa-binh' AND c.slug = 'van-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'tam-ly-hoc-ve-tien' AND c.slug = 'kinh-doanh';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'tam-ly-hoc-ve-tien' AND c.slug = 'tam-ly';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'dac-nhan-tam' AND c.slug = 'tam-ly';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'ong-gia-va-bien-ca' AND c.slug = 'van-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'bat-tre-dong-xanh' AND c.slug = 'van-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'vu-tru-cosmos' AND c.slug = 'khoa-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'toi-tu-hoc' AND c.slug = 'tam-ly';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'toi-tu-hoc' AND c.slug = 'triet-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'oc-sang-suot' AND c.slug = 'tam-ly';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'khac-ky-tu-a-den-z' AND c.slug = 'triet-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'nghe-thuat-tu-duy-ranh-mach' AND c.slug = 'tam-ly';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'tram-nam-co-don' AND c.slug = 'van-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'nhung-nguoi-khon-kho' AND c.slug = 'van-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'cay-cam-ngot-cua-toi' AND c.slug = 'van-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'chuyen-con-meo-day-hai-au-bay' AND c.slug = 'van-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'de-men-phieu-luu-ky' AND c.slug = 'van-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'so-do' AND c.slug = 'van-hoc';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'di-tim-le-song' AND c.slug = 'tam-ly';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'tu-duy-nhanh-va-cham' AND c.slug = 'tam-ly';
INSERT OR IGNORE INTO product_categories (product_id, category_id)
SELECT p.id, c.id FROM products p, categories c WHERE p.slug = 'tu-tot-den-vi-dai' AND c.slug = 'kinh-doanh';

-- ── 4. Static Markdown Pages ──────────────────────────────────────────────────
INSERT OR IGNORE INTO pages (title, slug, body_markdown, published)
VALUES (
  'Về Chúng Tôi (About Bookstore)',
  'about',
  '# Chào mừng đến với Bookstore Demo\n\nĐây là trang **Showcase Demo** của nền tảng thương mại điện tử mã nguồn mở chuyên về sách, được xây dựng dựa trên kiến trúc hiện đại **Astro (SSR) + Cloudflare Workers (D1, R2, KV)**.\n\n### 🌟 Điểm nổi bật\n- **Tốc độ vượt trội**: Server-Side Rendering với thời gian phản hồi chỉ tính bằng mili-giây tại Cloudflare Edge.\n- **Chi phí vận hành $0**: Hoạt động hoàn hảo trên gói Cloudflare Free Tier.\n- **Thân thiện & Tinh gọn**: Giao diện tối giản, tối ưu trải nghiệm đọc và mua sách.\n\n*Trân trọng cảm ơn bạn đã ghé thăm bản demo!*',
  1
);

INSERT OR IGNORE INTO pages (title, slug, body_markdown, published)
VALUES (
  'Chính Sách Vận Chuyển & Đổi Trả',
  'shipping-policy',
  '# Chính Sách Giao Hàng & Đổi Trả (Demo)\n\n### 🚚 Vận chuyển toàn quốc\n- **Tiêu chuẩn (Standard)**: 2 - 4 ngày làm việc.\n- **Hỏa tốc (Express)**: Trong vòng 24 giờ tại các thành phố lớn.\n\n### 🔄 Chính sách đổi trả\n- Hỗ trợ đổi trả miễn phí trong vòng **7 ngày** nếu sách bị lỗi in ấn, quăn gập hoặc hư hại trong quá trình vận chuyển.\n- Mọi thắc mắc xin vui lòng liên hệ bộ phận hỗ trợ khách hàng.',
  1
);

-- ── 5. Navigation Menu ────────────────────────────────────────────────────────
INSERT OR IGNORE INTO menu_items (location, target_type, target_id, label, position)
SELECT 'header', 'category', c.id, c.name, 1 FROM categories c WHERE c.slug = 'van-hoc';
INSERT OR IGNORE INTO menu_items (location, target_type, target_id, label, position)
SELECT 'header', 'category', c.id, c.name, 2 FROM categories c WHERE c.slug = 'triet-hoc';
INSERT OR IGNORE INTO menu_items (location, target_type, target_id, label, position)
SELECT 'header', 'category', c.id, c.name, 3 FROM categories c WHERE c.slug = 'khoa-hoc';
INSERT OR IGNORE INTO menu_items (location, target_type, target_id, label, position)
SELECT 'header', 'category', c.id, c.name, 4 FROM categories c WHERE c.slug = 'tam-ly';
INSERT OR IGNORE INTO menu_items (location, target_type, target_id, label, position)
SELECT 'footer', 'page', p.id, p.title, 1 FROM pages p WHERE p.slug = 'about';
INSERT OR IGNORE INTO menu_items (location, target_type, target_id, label, position)
SELECT 'footer', 'page', p.id, p.title, 2 FROM pages p WHERE p.slug = 'shipping-policy';

-- ── 6. Fixture Normalization (public_id) ──────────────────────────────────────
UPDATE products         SET public_id = 'prod_' || lower(substr(hex(randomblob(10)),1,10)) WHERE public_id IS NULL;
UPDATE categories       SET public_id = 'cat_'  || lower(substr(hex(randomblob(10)),1,10)) WHERE public_id IS NULL;
UPDATE pages            SET public_id = 'page_' || lower(substr(hex(randomblob(10)),1,10)) WHERE public_id IS NULL;
UPDATE menu_items       SET public_id = 'nav_'  || lower(substr(hex(randomblob(10)),1,10)) WHERE public_id IS NULL;
UPDATE product_images   SET public_id = 'pimg_' || lower(substr(hex(randomblob(10)),1,10)) WHERE public_id IS NULL;
