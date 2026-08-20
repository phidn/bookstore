# Security Policy & Architecture

## 1. Core Security Invariants

- **Fail-Closed Admin:** In production mode, `/admin` is locked if unconfigured or if credentials are missing. There is no open bypass path.
- **Encrypted Secret Vault:** Merchant provider keys (Stripe secret keys, webhook secrets, Lightning credentials, Resend tokens) are stored encrypted in D1 using AES-256-GCM under `SECRETS_KEK`. They are never returned in plain text via the Admin API.
- **Web Crypto Everywhere:** Cryptographic operations (signature verification, session signing, HMAC tokens, password hashing via PBKDF2 / Argon2 / WebCrypto) use standard Web Cryptography APIs available across Workers.
- **Markdown Script Prevention:** User/merchant content pages are processed through server-side markdown parsing with `html: false` to eliminate XSS risks.
- **Zero-Egress Private Storage:** R2 image assets are served via application proxy routes (`/images/[...key]`), keeping R2 buckets private without public bucket exposure.

---

## 2. Vulnerability Reporting

To report a vulnerability:
1. Open a GitHub Security Advisory: `https://github.com/phidn/bookstore/security/advisories/new`
2. Or contact the maintainer directly.

Reports receive initial triage within 72 hours.
