#!/bin/sh
set -eu

CERT_DIR="${CERT_DIR:-/certs}"
DAYS="${CERT_DAYS:-365}"
CN="${CERT_CN:-localhost}"
SAN="${CERT_SAN:-DNS:localhost,DNS:prometheus,IP:127.0.0.1}"

mkdir -p "$CERT_DIR"

if [ -f "$CERT_DIR/server.crt" ] && [ -f "$CERT_DIR/server.key" ]; then
  echo "Certificates already exist in $CERT_DIR, skipping generation."
  exit 0
fi

echo "Generating CA..."
openssl genrsa -out "$CERT_DIR/ca.key" 4096
openssl req -x509 -new -nodes -key "$CERT_DIR/ca.key" -sha256 \
  -days "$DAYS" -subj "/O=Local Dev/CN=Prometheus Local CA" \
  -out "$CERT_DIR/ca.crt"

echo "Generating server key and CSR..."
openssl genrsa -out "$CERT_DIR/server.key" 2048
openssl req -new -key "$CERT_DIR/server.key" \
  -subj "/O=Local Dev/CN=$CN" -out "$CERT_DIR/server.csr"

cat > "$CERT_DIR/server.ext" <<EXT
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage=digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth,clientAuth
subjectAltName=$SAN
EXT

echo "Signing server certificate..."
openssl x509 -req -in "$CERT_DIR/server.csr" \
  -CA "$CERT_DIR/ca.crt" -CAkey "$CERT_DIR/ca.key" -CAcreateserial \
  -out "$CERT_DIR/server.crt" -days "$DAYS" -sha256 \
  -extfile "$CERT_DIR/server.ext"

rm -f "$CERT_DIR/server.csr" "$CERT_DIR/server.ext" "$CERT_DIR/ca.srl"

# Prometheus image runs as nobody (65534)
chown -R 65534:65534 "$CERT_DIR"
chmod 644 "$CERT_DIR"/*.crt
chmod 600 "$CERT_DIR"/*.key

echo "Done. Generated files:"
ls -l "$CERT_DIR"
