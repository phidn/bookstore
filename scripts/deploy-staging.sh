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
ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID:-${ACCOUNT_ID:-}}"
SLUG="${SLUG:-bookstore-demo}"
DB_NAME="${SLUG}-db"
BUCKET="${SLUG}-images"
FILES_BUCKET="${SLUG}-files"
CONFIG="wrangler.staging.jsonc"
STAGING_DOMAIN="${STAGING_DOMAIN:-bookstore-demo.phidang.work}"
DB_ID="${CLOUDFLARE_D1_DATABASE_ID:-${DB_ID:-}}"

if [[ -n "$ACCOUNT_ID" ]]; then
  export CLOUDFLARE_ACCOUNT_ID="$ACCOUNT_ID"
fi

echo "▸ [1/6] D1 Database: $DB_NAME"
if [[ -z "$DB_ID" ]]; then
  echo "    Checking / Creating D1 database '$DB_NAME'…"
  DB_OUT="$($W d1 create "$DB_NAME" 2>&1 || true)"
  DB_ID="$(printf '%s' "$DB_OUT" | grep -oiE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' | head -1 || true)"
  if [[ -z "$DB_ID" ]]; then
    DB_ID="$($W d1 info "$DB_NAME" 2>/dev/null | grep -oiE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' | head -1 || true)"
  fi
fi
echo "    database_id=${DB_ID:-<dynamic>}"

echo "▸ [2/6] Checking / Creating R2 buckets..."
$W r2 bucket create "$BUCKET" 2>/dev/null || echo "    Bucket $BUCKET exists or created."
$W r2 bucket create "$FILES_BUCKET" 2>/dev/null || echo "    Bucket $FILES_BUCKET exists or created."

echo "▸ [3/6] Generating staging configuration..."
cat << EOF > "$CONFIG"
{
  "name": "$SLUG",
  "main": "./src/worker.ts",
  "compatibility_date": "2026-07-20",
  "compatibility_flags": ["nodejs_compat"],
  "observability": { "enabled": true, "traces": { "enabled": true, "head_sampling_rate": 1 } },
  "cache": { "enabled": false },
  "routes": [
    {
      "pattern": "$STAGING_DOMAIN",
      "custom_domain": true
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
    "IMAGE_BASE_URL": "https://tieuvienhuuthu.store/images",
    "CANONICAL_ORIGIN": "https://$STAGING_DOMAIN"
  }
}
EOF

restore() {
  [ -f wrangler.jsonc.bak ] && mv -f wrangler.jsonc.bak wrangler.jsonc || true
  rm -f "$CONFIG" || true
}
trap restore EXIT

echo "▸ [4/6] Swapping config & applying migrations to D1 $DB_NAME..."
[ -f wrangler.jsonc ] && cp wrangler.jsonc wrangler.jsonc.bak
cp "$CONFIG" wrangler.jsonc

CLOUDFLARE_ACCOUNT_ID="$ACCOUNT_ID" CI=1 $W d1 migrations apply DB --remote
if [[ -f seed-staging.sql ]]; then
  echo "    Seeding demo bookstore catalog (200+ books) into remote DB..."
  CLOUDFLARE_ACCOUNT_ID="$ACCOUNT_ID" CI=1 $W d1 execute DB --remote --file=./seed-staging.sql >/dev/null
  CLOUDFLARE_ACCOUNT_ID="$ACCOUNT_ID" CI=1 $W d1 execute DB --remote --command="INSERT INTO products_fts(products_fts) VALUES('rebuild');" >/dev/null 2>&1 || true
fi

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
