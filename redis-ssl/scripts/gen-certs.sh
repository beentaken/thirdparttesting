#!/bin/sh
set -eu

CERT_DIR=/certs
DAYS=3650
CA_SUBJ="/C=SG/ST=Singapore/L=Singapore/O=MyOrg/OU=CA/CN=MyRedisCA"
SRV_SUBJ="/C=SG/ST=Singapore/L=Singapore/O=MyOrg/OU=Redis/CN=redis"
CLI_SUBJ="/C=SG/ST=Singapore/L=Singapore/O=MyOrg/OU=Client/CN=celery-client"

mkdir -p "$CERT_DIR"
cd "$CERT_DIR"

# Idempotent: skip if certs already exist (unless FORCE=1)
if [ "${FORCE:-0}" != "1" ] && [ -f ca.crt ] && [ -f redis.crt ]; then
  echo "[gen-certs] certificates already exist, skipping (set FORCE=1 to regenerate)"
  exit 0
fi

echo "[gen-certs] generating CA..."
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -sha256 -days $DAYS \
  -key ca.key -out ca.crt -subj "$CA_SUBJ"

echo "[gen-certs] generating server cert..."
openssl genrsa -out redis.key 4096
openssl req -new -sha256 -key redis.key -out redis.csr -subj "$SRV_SUBJ"

cat > redis.ext <<EOF
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = redis
DNS.2 = localhost
DNS.3 = redis.local
IP.1 = 127.0.0.1
EOF

openssl x509 -req -sha256 -days $DAYS \
  -in redis.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out redis.crt -extfile redis.ext

echo "[gen-certs] generating client cert..."
openssl genrsa -out client.key 4096
openssl req -new -sha256 -key client.key -out client.csr -subj "$CLI_SUBJ"

cat > client.ext <<EOF
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth
EOF

openssl x509 -req -sha256 -days $DAYS \
  -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out client.crt -extfile client.ext

# Permissions — Redis container runs as UID 999 (redis user)
chmod 600 redis.key client.key ca.key
chmod 644 redis.crt client.crt ca.crt
chown -R 999:999 "$CERT_DIR" 2>/dev/null || true

echo "[gen-certs] done. files:"
ls -la "$CERT_DIR"