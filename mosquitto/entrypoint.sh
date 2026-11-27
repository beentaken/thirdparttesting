#!/bin/sh
set -e

CERT_DIR="${CERT_DIR:-/mosquitto/certs}"
CERT_CN="${CERT_CN:-mosquitto}"
CERT_SAN="${CERT_SAN:-DNS:mosquitto,DNS:localhost,IP:127.0.0.1}"
CERT_DAYS="${CERT_DAYS:-365}"
CERT_PFX_PASSWORD="${CERT_PFX_PASSWORD:-changeit}"

mkdir -p "$CERT_DIR"
cd "$CERT_DIR"

if [ ! -f server.crt ] || [ ! -f server.key ]; then
  echo "[entrypoint] Generating CA and server certificate in $CERT_DIR"

  # CA
  openssl genrsa -out ca.key 4096
  openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 \
    -subj "/CN=Mosquitto Local CA" -out ca.crt

  # Server key + CSR
  openssl genrsa -out server.key 2048
  openssl req -new -key server.key -subj "/CN=${CERT_CN}" -out server.csr

  # Sign with SAN
  printf "subjectAltName=%s\nextendedKeyUsage=serverAuth\n" "$CERT_SAN" > san.ext
  openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
    -out server.crt -days "$CERT_DAYS" -sha256 -extfile san.ext

  rm -f server.csr san.ext
  chown -R mosquitto:mosquitto "$CERT_DIR"
  chmod 640 server.key ca.key
  chmod 644 ca.crt server.crt
else
  echo "[entrypoint] Existing certificates found, skipping generation"
fi

# Derived copies for other apps (cert.pem, key.pem, cert.pfx).
# Created separately so they also appear on existing volumes.
if [ ! -f cert.pfx ]; then
  echo "[entrypoint] Creating cert.pem, key.pem, cert.pfx"
  cp server.crt cert.pem
  cp server.key key.pem
  openssl pkcs12 -export -out cert.pfx \
    -inkey server.key -in server.crt -certfile ca.crt \
    -passout "pass:${CERT_PFX_PASSWORD}"
  chmod 644 cert.pem key.pem cert.pfx   # dev convenience: key.pem is world-readable
fi

exec "$@"
