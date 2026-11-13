#!/bin/bash

# Create certs directory if it doesn't exist
mkdir -p certs

# Generate self-signed certificate
openssl req -new -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout certs/tls.key \
  -out certs/tls.crt \
  -subj '/C=US/ST=State/L=City/O=Organization/CN=localhost'

# Set proper permissions
chmod 600 certs/tls.key
chmod 644 certs/tls.crt

echo "Certificates generated successfully!"