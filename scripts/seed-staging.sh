#!/usr/bin/env bash
#
# Seed local D1 database with Staging / Demo data from tieuvienhuuthu.store
# (200+ books, 16 categories, media metadata, store settings).
#
#   Usage:  scripts/seed-staging.sh [--no-reset] [--remote]
#   --no-reset: skip clearing existing tables before seeding.
#   --remote:   seed into remote D1 (caution!).
#
set -euo pipefail

RESET=1
REMOTE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-reset) RESET=0; shift ;;
    --remote) REMOTE=1; shift ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
  esac
done

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
W="npx --yes wrangler"
TARGET="--local"
WHERE="local"
if [[ "$REMOTE" == "1" ]]; then
  TARGET="--remote"
  WHERE="DEPLOYED"
fi

# Ensure secrets and IMAGE_BASE_URL in .dev.vars for local
ensure_devvar() {
  local name="$1"
  local val="$2"
  [[ -f .dev.vars ]] || : > .dev.vars
  if ! grep -qE "^${name}=" .dev.vars; then
    [[ -s .dev.vars && -n "$(tail -c1 .dev.vars)" ]] && printf '\n' >> .dev.vars
    printf '%s=%s\n' "$name" "$val" >> .dev.vars
    echo "  • set ${name} → .dev.vars"
  fi
}

if [[ "$REMOTE" == "0" ]]; then
  echo "▸ Ensuring local config in .dev.vars…"
  ensure_devvar SECRETS_KEK "$(openssl rand -base64 32)"
  ensure_devvar AUTH_SECRET "$(openssl rand -base64 32)"
  ensure_devvar IMAGE_BASE_URL "https://tieuvienhuuthu.store/images"
fi

if [[ "$RESET" == "1" ]]; then
  echo "▸ [1/3] Clearing tables in $WHERE D1…"
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
  CI=1 $W d1 execute DB $TARGET --command "$RESET_SQL" >/dev/null 2>&1 || true
fi

echo "▸ [2/3] Executing seed-staging.sql on $WHERE D1…"
[[ -f seed-staging.sql ]] || { echo "✗ seed-staging.sql not found!" >&2; exit 1; }
CI=1 $W d1 execute DB $TARGET --file=./seed-staging.sql >/dev/null

echo "▸ [3/3] Rebuilding full-text search (FTS5) index…"
CI=1 $W d1 execute DB $TARGET --command "INSERT INTO products_fts(products_fts) VALUES('rebuild');" >/dev/null 2>&1 || true

cat <<EOF

✓ Staging / Demo data seeded successfully to $WHERE D1!
  • 200+ Books & Products (Tiểu Viện Hữu Thư catalog)
  • 16 Book Categories
  • Real Cover Images mapped via CDN (IMAGE_BASE_URL)
  • Store Settings: Tiểu Viện Hữu Thư, VND, Asia/Saigon

EOF
