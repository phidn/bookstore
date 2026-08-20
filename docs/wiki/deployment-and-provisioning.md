# Deployment & Provisioning

## 1. Scaffolding a New Store

You can scaffold a clean store instance using `create-bookstore`:

```sh
npm create bookstore@latest my-store
cd my-store
npm run provision:local -- --seed
npm run dev
```

---

## 2. Cloudflare Infrastructure Provisioning

To provision live resources on Cloudflare:

```sh
npx wrangler login
npm run provision:cf my-store
```

This automated script sets up:
1. **Cloudflare D1 Database:** Named and bound in `wrangler.jsonc`.
2. **Cloudflare R2 Bucket:** For media uploads.
3. **Database Migrations:** Executes `npm run db:migrate:remote`.
4. **Environment Secrets:** Generates and deploys `SECRETS_KEK` and `AUTH_SECRET`.

---

## 3. Remote Migrations & Deployment

Before deploying changes to production:

```sh
# Apply pending D1 migrations remotely
npm run db:migrate:remote

# Run the complete verification gate
npm run verify

# Deploy the storefront Worker
npm run deploy

# Deploy the MCP Worker (if enabled)
cd mcp && npm run deploy
```
