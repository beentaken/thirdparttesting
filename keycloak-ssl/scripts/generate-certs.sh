#!/bin/bash

# Generate self-signed certificates for Keycloak SSL
echo "Generating self-signed certificates for Keycloak..."

# Create directory structure
mkdir -p certs

# Generate private key
openssl genrsa -out certs/tls.key 2048

# Generate certificate
openssl req -new -x509 -key certs/tls.key -out certs/tls.crt -days 365 -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Set proper permissions
chmod 600 certs/tls.key
chmod 644 certs/tls.crt

echo "Certificates generated successfully!"
echo "Files created:"
echo "  - certs/tls.key"
echo "  - certs/tls.crt"
