# Agent API & Model Context Protocol (MCP)

## 1. Overview

**bookstore** provides dual interfaces for autonomous AI agents:
1. **Public Agent REST API:** Allows AI agents to discover, browse, and purchase products autonomously without scraping HTML.
2. **Model Context Protocol (MCP) Worker:** A standalone MCP server with separate **Buyer** (public) and **Operator** (authenticated merchant) tool tiers.

---

## 2. Public Agent REST API

All endpoints return structured JSON with absolute URLs and open CORS:

| Method & Route | Description |
|---|---|
| `GET /api/products` | Paginated catalog. Supports `?q=` (keyword or semantic vector search), `?limit=`, `?offset=` |
| `GET /api/products/:slug` | Detailed product projection with variants and options |
| `GET /api/checkout` | Lists active payment methods and defaults |
| `POST /api/checkout` | Programmatic checkout creation. Expects `{ "items": [{ "product_id": "prod_...", "quantity": 1 }], "method": "lightning" }` |
| `GET /order/:token/status` | Polling endpoint for checkout status (`confirming`, `paid`, `expired`) and digital download links |

### Identifiers
- Public IDs are prefixed (e.g. `prod_...`, `var_...`, `xtra_...`, `ord_...`).
- Legacy database numeric IDs are strictly rejected with 400 Bad Request.

---

## 3. Standalone MCP Server (`mcp/`)

The MCP server runs as a separate Worker binding the same D1 database.

### Buyer Tier (Unauthenticated, Rate-Limited)
- `list_products`: Search and list catalog items with pagination.
- `get_product`: Fetch full product details by public ID or slug.
- `create_checkout`: Initiate autonomous checkout (returns Lightning BOLT11 invoice or Stripe URL).
- `check_order`: Poll order confirmation and retrieve deliverable download tokens.

### Operator Tier (Bearer Token Authenticated)
- Requires `Authorization: Bearer <MCP_TOKEN>`.
- Tools: `create_product`, `update_product`, `delete_product`, `list_orders`, `get_order`, `fulfill_order`, `refund_order`.

### MCP Setup & Verification
```sh
cd mcp && npm install && cd ..
cp mcp/.dev.vars.example mcp/.dev.vars
npm run mcp:check
```
*Note:* MCP dependencies must strictly stay in `mcp/package.json` and never leak into root.
