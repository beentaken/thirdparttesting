#!/bin/sh

set -eu

CERT_DIR="/certs"

mkdir -p "$CERT_DIR"

echo "Generating IBM MQ SSL certificate..."

openssl req \
    -x509 \
    -newkey rsa:2048 \
    -sha256 \
    -days 825 \
    -nodes \
    -keyout "$CERT_DIR/tls.key" \
    -out "$CERT_DIR/tls.crt" \
    -subj "/CN=localhost/O=Development/OU=IBM MQ" \
    -addext "subjectAltName=DNS:localhost,DNS:ibm-mq,IP:127.0.0.1"

# IBM MQ container user is normally UID 1001.
chown 1001:0 "$CERT_DIR/tls.key" "$CERT_DIR/tls.crt" || true

chmod 640 "$CERT_DIR/tls.key"
chmod 644 "$CERT_DIR/tls.crt"

echo "Certificate generated successfully."

openssl x509 \
    -in "$CERT_DIR/tls.crt" \
    -noout \
    -subject \
    -dates \
    -ext subjectAltName
