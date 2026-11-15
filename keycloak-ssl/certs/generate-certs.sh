
#!/bin/sh

set -e

echo "Installing OpenSSL..."

apk add --no-cache openssl

mkdir -p /certs

if [ -f /certs/tls.crt ] && [ -f /certs/tls.key ]; then
    echo "Existing certificate found. Skipping generation."
    exit 0
fi

echo "Generating private key..."

openssl genrsa -out /certs/tls.key 2048

echo "Generating self-signed certificate..."

openssl req -x509 \
    -new \
    -nodes \
    -key /certs/tls.key \
    -sha256 \
    -days 3650 \
    -out /certs/tls.crt \
    -subj "/C=SG/ST=Singapore/L=Singapore/O=Development/OU=Keycloak/CN=localhost" \
    -addext "subjectAltName=DNS:localhost,IP:127.0.0.1,IP:::1" \
    -addext "keyUsage=digitalSignature,keyEncipherment" \
    -addext "extendedKeyUsage=serverAuth"

chmod 644 /certs/tls.crt
chmod 600 /certs/tls.key

echo "--------------------------------"
echo "Certificate generation complete"
echo "--------------------------------"

openssl x509 -in /certs/tls.crt -noout -subject -dates
