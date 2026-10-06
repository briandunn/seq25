#!/usr/bin/env bash
# Deploys seq25 on the host it runs on: the backend as the seq25-prod compose stack,
# the frontend as static files the host nginx serves (deploy/nginx/seq25.conf).
#
# One-time setup, as root:
#   install -d -o "$USER" /var/www/seq25
#
# Deploys the committed tree; set ALLOW_DIRTY=1 to deploy local changes.
set -euo pipefail
cd "$(dirname "$0")"

WEB_ROOT=${WEB_ROOT:-/var/www/seq25}

if [[ ! -w $WEB_ROOT ]]; then
  echo "$WEB_ROOT isn't writable; run: sudo install -d -o $USER $WEB_ROOT" >&2
  exit 1
fi

if [[ -z ${ALLOW_DIRTY:-} && -n $(git status --porcelain) ]]; then
  echo "Uncommitted changes; commit them or set ALLOW_DIRTY=1." >&2
  exit 1
fi

echo "==> backend"
docker compose -f compose.prod.yaml up -d --build --wait

echo "==> frontend build"
# The dev image has the toolchain; it writes frontend/dist through the mount.
docker compose build frontend
docker compose run --rm --no-deps -T frontend aube run build

echo "==> publish to $WEB_ROOT"
# Assets are content-hashed, so copy them first and index.html last: a page
# loaded mid-deploy never references an asset that isn't there yet.
rsync -a frontend/dist/assets/ "$WEB_ROOT/assets/"
rsync -a --exclude /index.html --exclude /assets/ frontend/dist/ "$WEB_ROOT/"
rsync -a frontend/dist/index.html "$WEB_ROOT/index.html"
# Then drop files from older builds.
rsync -a --delete frontend/dist/ "$WEB_ROOT/"

echo "==> check"
curl -fsS -o /dev/null http://127.0.0.1:3025/songs
echo "backend answering on 127.0.0.1:3025; deployed $(git rev-parse --short HEAD)"
