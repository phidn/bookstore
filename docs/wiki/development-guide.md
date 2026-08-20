# Development Guide & Workflow

## 1. Prerequisites
- **Node.js:** Node ≥ 22.12 (`nvm use 22` is required; this is the tested/supported toolchain).
- **Git**
- **Cloudflare Wrangler CLI** (`npx wrangler`)

---

## 2. Local Setup & Quickstart

```sh
nvm use 22
npm install

# Build, migrate + seed the local DB, and generate local secrets (.dev.vars)
npm run provision:local -- --seed

# Start development server
npm run dev
```

The local development server runs at `http://localhost:4321` with Admin accessible at `/admin`.

---

## 3. The Verification Gate (Run Constantly)

The single authority that a change is sound is:

```sh
npm run verify
```

`npm run verify` runs the complete quality gate:
1. **Unit tests:** Vitest suite (`npm test`).
2. **Astro check:** Full typechecking & diagnostics (`npm run check`).
3. **Production build:** Full Astro build for Cloudflare Workers.
4. **D1 integration:** Clean-room migration and integration testing.
5. **MCP check:** Typechecking and dry-run build for the MCP server.

Run `npm run verify` after every meaningful code modification.

### Focused Testing Loops
- `npm test`: Unit tests via Vitest.
- `npm run check`: TypeScript and Astro component diagnostics.
- `npm run preview`: Runs Wrangler in production mode (essential to test middleware, sessions, and auth).
- `npm run test:storefront-equivalence`: Verifies template refactors preserve rendered HTML output.
- `npm run db:migrate`: Applies local D1 migrations.

---

## 4. Inspecting Local Data: Local Explorer

Local dev servers (`npm run dev`, `npm run preview`) serve Cloudflare's **Local Explorer**:
- **UI:** `http://localhost:4321/cdn-cgi/explorer`
- **REST API:** `http://localhost:4321/cdn-cgi/explorer/api`

Prefer the Local Explorer over `npx wrangler d1 execute --local` for inspecting D1 / KV / R2 state (~0.02s HTTP call vs ~1.2s process spawn).

Example query:
```sh
curl -s localhost:4321/cdn-cgi/explorer/api/d1/database/DB/raw \
  -H 'content-type: application/json' \
  -d '{"sql":"SELECT status, COUNT(*) FROM orders GROUP BY status"}'
```

---

## 5. Development Conventions & Gotchas

- **Pure Unit Tests:** Never import `cloudflare:workers` in `*.test.ts` (Vitest cannot resolve it). Pass `db` and environment secrets as parameters to pure functions.
- **Colocation:** Keep unit tests colocated (`feature.ts` alongside `feature.test.ts`).
- **Astro Expressions:** Avoid bare `<` or `<=` inside `{expression}` in `.astro` files (Astro parses `<` as a tag open). Flip operands (`0 >= x`) or calculate boolean values in frontmatter.
- **CSRF Protection:** Astro blocks cross-origin form POSTs (403). `curl` tests must pass `-H "Origin: http://localhost:4321"`.
- **MCP Worker Isolation:** The `mcp/` worker has its own `package.json` and `node_modules`. Never install `@modelcontextprotocol/sdk` or `agents` in the root `package.json`.
