#!/usr/bin/env bash
#
# Seed local D1 database with clean local dev sample data (seed.sql).
#
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
W="npx --yes wrangler"

echo "▸ [1/3] Clearing tables in local D1…"
RESET_SQL="
DELETE FROM order_notifications;
DELETE FROM order_items;
DELETE FROM product_categories;
DELETE FROM product_extras;
DELETE FROM product_images;
DELETE FROM product_variants;
DELETE FROM pending_payments;
DELETE FROM orders;
DELETE FROM products;
DELETE FROM categories;
DELETE FROM media;
DELETE FROM settings;
"
CI=1 $W d1 execute DB --local --command "$RESET_SQL" >/dev/null 2>&1 || true

echo "▸ [2/3] Executing scripts/sqls/seed.sql on local D1…"
CI=1 $W d1 execute DB --local --file=./scripts/sqls/seed.sql

echo "▸ [3/3] Rebuilding full-text search (FTS5) index…"
CI=1 $W d1 execute DB --local --command "INSERT INTO products_fts(products_fts) VALUES('rebuild');" >/dev/null 2>&1 || true

cat <<EOF

✓ Clean local dev data seeded successfully to local D1!
  • Minimal sample products (Sample Tee, Sample Mug)
  • Ready for fresh testing / setup wizard

EOF


