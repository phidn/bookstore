#!/usr/bin/env bash
#
# Sync / Export latest real data from Cloudflare Production D1 into seed-staging.sql
#
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

DB_NAME="${1:-${CLOUDFLARE_D1_DB_NAME:-tieuvienhuuthu-store-db}}"

echo "▸ Syncing latest bookstore catalog from remote Cloudflare Production D1 ($DB_NAME)…"
npx --yes wrangler d1 export "$DB_NAME" \
  --remote \
  --no-schema \
  --table categories \
  --table products \
  --table product_categories \
  --table product_images \
  --table product_variants \
  --table product_extras \
  --table media \
  --output=seed-staging.sql \
  -y

echo "✓ seed-staging.sql updated successfully ($(wc -l < seed-staging.sql | tr -d ' ') lines)!"
