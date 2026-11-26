#!/usr/bin/env sh
# Usage: ./run.sh openssl | ./run.sh certbot
set -e
PROFILE="${1:-openssl}"
case "$PROFILE" in
  openssl) docker compose --profile openssl up certgen ;;
  certbot) docker compose --profile certbot up certbot ;;
  *) echo "usage: $0 [openssl|certbot]"; exit 1 ;;
esac
