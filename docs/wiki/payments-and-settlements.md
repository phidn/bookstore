# Payments & Settlements

## 1. Supported Payment Rails

| Rail | Type | Features & Integration |
|---|---|---|
| **Stripe** | Hosted Checkout | Credit/Debit card, Apple Pay, Google Pay, Stripe Tax calculation, Stripe Coupons |
| **Bitcoin Lightning** | Non-custodial Invoice | Self-hosted backend: **phoenixd** or **LNbits**; BOLT11 invoices, QR display, real-time polling |
| **OpenNode** | Hosted Crypto Gateway | Bitcoin on-chain & Lightning hosted checkout |
| **Demo** | Test / Mock | Simulates instant checkout and order settlement in development and staging |

---

## 2. Ports & Adapters Architecture

Payment processing lives entirely behind the `PaymentProvider` interface in `src/features/payments/provider.ts`:

```ts
export interface PaymentProvider {
  createSession(options: PaymentSessionOptions): Promise<PaymentSessionResult>;
  verifyWebhook(request: Request): Promise<PaymentWebhookEvent | null>;
  handleWebhook(event: PaymentWebhookEvent, db: D1Database): Promise<void>;
}
```

- Webhook endpoints (`/api/webhook/[provider]`) delegate to provider adapters.
- Core checkout routes never depend directly on vendor SDKs.

---

## 3. Order Lifecycle & Settlement Rules

1. **Orders Table is Paid-Only:** Unpaid or in-flight checkouts are **never** inserted into the `orders` table.
2. **Pending Payments:** In-flight Lightning invoices are held in `pending_payments` with an expiration timestamp.
3. **Lightning Node Polling (Zero Trust Webhooks):** Webhooks from Lightning nodes are treated as unverified nudges; true settlement authority is verified by re-polling the backend via `backend.getIncoming(paymentHash)`.
4. **Atomic Stock Holds:** Stock reservations are created atomically during checkout initiation and released if the session expires without payment.
5. **Money Representation:** All prices, tax, shipping, and discounts are handled in integer minor units (cents / satoshis) to prevent floating-point rounding bugs.

---

## 4. Provider Key Management (Secret Vault)

- Credentials (Stripe API Keys, Webhook Secrets, Lightning Node Passwords/Tokens) are configured exclusively via **Admin → Settings → Payments**.
- Credentials are encrypted in D1 using AES-GCM with a Key Encryption Key (`SECRETS_KEK`).
- Provider secrets are **write-only** from the admin UI and cannot be read back in plain text over the admin API.
