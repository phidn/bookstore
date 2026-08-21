#!/usr/bin/env bash
#
# Provision / Deploy Staging Demo Bookstore to Cloudflare
# Target Domain: bookstore-demo.phidang.work
# Environment: STAGING
#
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
W="npx --yes wrangler"
ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID:-${ACCOUNT_ID:-32659d68e9b3f45c93b9ab75db3b5d23}}"
SLUG="${SLUG:-bookstore-demo}"
DB_NAME="${SLUG}-db"
BUCKET="${SLUG}-images"
FILES_BUCKET="${SLUG}-files"
CONFIG="wrangler.staging.jsonc"
STAGING_DOMAIN="${STAGING_DOMAIN:-bookstore-demo.phidang.work}"
DB_ID="${CLOUDFLARE_D1_DATABASE_ID:-${DB_ID:-}}"

export CLOUDFLARE_ACCOUNT_ID="$ACCOUNT_ID"

# Backup canonical wrangler.jsonc
[ -f wrangler.jsonc ] && cp -f wrangler.jsonc wrangler.jsonc.bak
restore() {
  [ -f wrangler.jsonc.bak ] && mv -f wrangler.jsonc.bak wrangler.jsonc || true
  rm -f "$CONFIG" || true
}
trap restore EXIT

# Write initial staging config so all wrangler commands target ACCOUNT_ID
cat << EOF > "$CONFIG"
{
  "account_id": "$ACCOUNT_ID",
  "name": "$SLUG",
  "main": "./src/worker.ts",
  "compatibility_date": "2026-07-20",
  "compatibility_flags": ["nodejs_compat"]
}
EOF
cp -f "$CONFIG" wrangler.jsonc

echo "▸ [1/6] D1 Database: $DB_NAME in account $ACCOUNT_ID"
if [[ -z "$DB_ID" ]]; then
  echo "    Checking / Creating D1 database '$DB_NAME'…"
  DB_OUT="$($W d1 create "$DB_NAME" 2>&1 || true)"
  DB_ID="$(printf '%s' "$DB_OUT" | grep -oiE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' | head -1 || true)"
  if [[ -z "$DB_ID" ]]; then
    DB_ID="$($W d1 list 2>/dev/null | grep -E "\b$DB_NAME\b" | grep -oiE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' | head -1 || true)"
  fi
fi
echo "    database_id=${DB_ID:-<dynamic>}"

echo "▸ [2/6] Checking / Creating R2 buckets..."
$W r2 bucket create "$BUCKET" 2>/dev/null || echo "    Bucket $BUCKET exists or created."
$W r2 bucket create "$FILES_BUCKET" 2>/dev/null || echo "    Bucket $FILES_BUCKET exists or created."

echo "▸ [3/6] Generating full staging configuration..."
cat << EOF > "$CONFIG"
{
  "account_id": "$ACCOUNT_ID",
  "name": "$SLUG",
  "main": "./src/worker.ts",
  "compatibility_date": "2026-07-20",
  "compatibility_flags": ["nodejs_compat"],
  "observability": { "enabled": true, "traces": { "enabled": true, "head_sampling_rate": 1 } },
  "cache": { "enabled": false },
  "workers_dev": false,
  "routes": [
    {
      "pattern": "bookstore-demo.phidang.work/*",
      "zone_name": "phidang.work"
    }
  ],
  "ratelimits": [
    { "name": "AUTH_RATE_LIMITER", "namespace_id": "20001", "simple": { "limit": 10, "period": 60 } },
    { "name": "CHECKOUT_RATE_LIMITER", "namespace_id": "20002", "simple": { "limit": 20, "period": 60 } },
    { "name": "SEARCH_RATE_LIMITER", "namespace_id": "20003", "simple": { "limit": 60, "period": 60 } }
  ],
  "d1_databases": [
    {
      "binding": "DB",
      "database_name": "$DB_NAME",
      "database_id": "$DB_ID",
      "migrations_dir": "migrations"
    }
  ],
  "r2_buckets": [
    { "binding": "BUCKET", "bucket_name": "$BUCKET" },
    { "binding": "FILES", "bucket_name": "$FILES_BUCKET" }
  ],
  "vars": {
    "STORE_NAME": "Tiểu Viện Hữu Thư (Demo)",
    "ENVIRONMENT": "staging",
    "TIME_ZONE": "Asia/Saigon",
    "CANONICAL_ORIGIN": "https://$STAGING_DOMAIN"
  }
}
EOF

echo "▸ [4/6] Swapping config & applying migrations to D1 $DB_NAME..."
cp -f "$CONFIG" wrangler.jsonc

CLOUDFLARE_ACCOUNT_ID="$ACCOUNT_ID" CI=1 $W d1 migrations apply DB --remote
echo "    Clearing old products and seeding curated demo catalog into remote DB..."
CLOUDFLARE_ACCOUNT_ID="$ACCOUNT_ID" CI=1 $W d1 execute DB --remote --command="
DROP TRIGGER IF EXISTS products_fts_ai;
DROP TRIGGER IF EXISTS products_fts_ad;
DROP TRIGGER IF EXISTS products_fts_au;
DROP TABLE IF EXISTS products_fts;
DELETE FROM product_categories;
DELETE FROM product_images;
DELETE FROM product_variants;
DELETE FROM product_extras;
DELETE FROM products;
DELETE FROM categories;
DELETE FROM page_media;
DELETE FROM pages;
DELETE FROM menu_items;
" >/dev/null 2>&1 || true

CLOUDFLARE_ACCOUNT_ID="$ACCOUNT_ID" CI=1 $W d1 execute DB --remote --file=./scripts/sqls/seed-demo.sql >/dev/null
CLOUDFLARE_ACCOUNT_ID="$ACCOUNT_ID" CI=1 $W d1 execute DB --remote --command="
CREATE VIRTUAL TABLE IF NOT EXISTS products_fts USING fts5(
  name,
  description,
  content='products',
  content_rowid='id'
);
INSERT INTO products_fts(rowid, name, description)
  SELECT id, name, description FROM products;
CREATE TRIGGER IF NOT EXISTS products_fts_ai AFTER INSERT ON products BEGIN
  INSERT INTO products_fts(rowid, name, description)
    VALUES (new.id, new.name, new.description);
END;
CREATE TRIGGER IF NOT EXISTS products_fts_ad AFTER DELETE ON products BEGIN
  INSERT INTO products_fts(products_fts, rowid, name, description)
    VALUES ('delete', old.id, old.name, old.description);
END;
CREATE TRIGGER IF NOT EXISTS products_fts_au AFTER UPDATE ON products BEGIN
  INSERT INTO products_fts(products_fts, rowid, name, description)
    VALUES ('delete', old.id, old.name, old.description);
  INSERT INTO products_fts(rowid, name, description)
    VALUES (new.id, new.name, new.description);
END;
" >/dev/null 2>&1 || true

echo "▸ [5/6] Building storefront (astro build)..."
CLOUDFLARE_ACCOUNT_ID="$ACCOUNT_ID" ENVIRONMENT=staging npx --yes astro build

echo "▸ [6/6] Deploying worker to Cloudflare (bookstore-demo.phidang.work)..."
CLOUDFLARE_ACCOUNT_ID="$ACCOUNT_ID" $W deploy

cat << 'DONE'

========================================================================
🎉 Staging Demo Bookstore deployed successfully!
👉 Custom Domain: https://bookstore-demo.phidang.work
👉 Admin Portal:  https://bookstore-demo.phidang.work/admin
👉 Environment:    STAGING / DEMO DATA (Image tags active)
========================================================================

DONE
