#!/bin/bash

echo "Setting up Keycloak with SSL..."

# Create directories if they don't exist
mkdir -p certs postgres-data data

# Check if certificates already exist
if [ ! -f certs/tls.crt ] || [ ! -f certs/tls.key ]; then
    echo "Generating self-signed certificates..."
    
    # Generate private key
    openssl genrsa -out certs/tls.key 2048
    
    # Generate certificate
    openssl req -new -x509 -key certs/tls.key -out certs/tls.crt -days 365 -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
    
    echo "Certificates generated successfully"
else
    echo "Certificates already exist, skipping generation"
fi

# Set proper permissions
chmod 600 certs/tls.key
chmod 644 certs/tls.crt

echo "Starting Keycloak with PostgreSQL..."
docker compose up -d

echo "Keycloak setup complete. Access at https://localhost:8443"
echo "Admin credentials: admin / admin"

# Wait a moment and check status
sleep 5
echo "Checking service status:"
docker compose ps
