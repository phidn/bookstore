# ADR 002: Ports and Adapters (Hexagonal Architecture) for External Services

## Trạng thái (Status)
**Accepted**

## Bối cảnh (Context)
Cửa hàng cần hỗ trợ nhiều nhà cung cấp thanh toán (Stripe, Bitcoin Lightning qua Phoenixd/LNbits, OpenNode, Demo), nhiều nhà cung cấp email (Resend, Cloudflare Email), và khả năng mở rộng backend tìm kiếm hoặc lưu trữ mà không làm xáo trộn luồng checkout hoặc core domain logic.

## Quyết định (Decision)
Tách biệt toàn bộ logic giao tiếp bên ngoài thông qua mô hình Ports & Adapters:
- `PaymentProvider` (`src/features/payments/provider.ts`): Cung cấp adapter cho Stripe, Lightning, OpenNode, Demo.
- `StorageProvider` (`src/features/storage/provider.ts`): Cung cấp adapter cho R2.
- `EmailProvider` (`src/features/email/provider.ts`): Cung cấp adapter cho Resend, Cloudflare Email.
- `SearchProvider` (`src/features/search/provider.ts`): Cung cấp adapter cho FTS5 SQLite và Vector Search.

Các controller như `checkout.ts` hay webhook handler chỉ tương tác với interface/factory, không phụ thuộc trực tiếp vào vendor SDK.

## Hệ quả (Consequences)
- Dễ dàng thay thế hoặc bổ sung cổng thanh toán / dịch vụ lưu trữ mới chỉ bằng 1 file adapter.
- Unit test độc lập, dễ dàng mock và kiểm thử.
