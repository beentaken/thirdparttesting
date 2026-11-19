#!/usr/bin/env bash
# Generates a CA, a RabbitMQ server cert (with SAN) and a client cert.
set -euo pipefail

CERT_DIR="${CERT_DIR:-$(dirname "$0")/certs}"
HOST="${1:-${CERT_HOST:-localhost}}"   # server hostname / CN (name clients connect to)
DAYS=825
mkdir -p "$CERT_DIR" && cd "$CERT_DIR"

# Idempotent: skip if certs already exist
if [ -f server_certificate.pem ] && [ -f server_key.pem ] && [ -f ca_certificate.pem ]; then
  echo "Certs already exist in $CERT_DIR, skipping."
  exit 0
fi

# 1. Certificate Authority
openssl genrsa -out ca_key.pem 4096
openssl req -x509 -new -nodes -key ca_key.pem -sha256 -days 3650 \
  -subj "/CN=MyRabbitCA/O=Dev" -out ca_certificate.pem

# 2. Server key + CSR + signed cert (SAN is required by modern clients)
openssl genrsa -out server_key.pem 2048
openssl req -new -key server_key.pem -subj "/CN=${HOST}/O=Dev" -out server.csr
cat > server_ext.cnf <<EXT
subjectAltName = DNS:${HOST}, DNS:rabbitmq, DNS:localhost, IP:127.0.0.1
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
EXT
openssl x509 -req -in server.csr -CA ca_certificate.pem -CAkey ca_key.pem \
  -CAcreateserial -out server_certificate.pem -days $DAYS -sha256 -extfile server_ext.cnf

# 3. Client key + cert (only needed for mutual TLS)
openssl genrsa -out client_key.pem 2048
openssl req -new -key client_key.pem -subj "/CN=client/O=Dev" -out client.csr
cat > client_ext.cnf <<EXT
basicConstraints = CA:FALSE
keyUsage = digitalSignature
extendedKeyUsage = clientAuth
EXT
openssl x509 -req -in client.csr -CA ca_certificate.pem -CAkey ca_key.pem \
  -CAcreateserial -out client_certificate.pem -days $DAYS -sha256 -extfile client_ext.cnf

rm -f *.csr *.cnf *.srl
chmod 644 *.pem
chmod 600 server_key.pem client_key.pem ca_key.pem
# RabbitMQ in the official image runs as uid/gid 999
if [ "$(id -u)" = "0" ]; then chown 999:999 server_key.pem ca_certificate.pem server_certificate.pem; fi
echo "Certs written to $CERT_DIR"
