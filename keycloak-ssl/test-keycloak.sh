#!/bin/bash

echo "Testing Keycloak SSL setup..."

# Check if certificates exist
if [ ! -f certs/tls.crt ] || [ ! -f certs/tls.key ]; then
    echo "Error: SSL certificates not found!"
    exit 1
fi

echo "SSL certificates found:"
ls -la certs/

echo "Starting Keycloak with SSL..."
docker-compose up -d

# Wait a moment for startup
sleep 5

# Check if Keycloak is running
if docker ps | grep -q keycloak; then
    echo "Keycloak is running successfully!"
    echo "Access at: https://localhost:8443"
    echo "Admin user: admin / admin"
else
    echo "Error: Keycloak failed to start"
    docker-compose logs keycloak
fi
