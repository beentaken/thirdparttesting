#!/bin/bash

echo "Setting up Keycloak with SSL..."

# Make scripts executable
chmod +x keycloak-ssl/scripts/generate-certs.sh
chmod +x keycloak-ssl/scripts/create-truststore.sh

# Generate certificates
echo "Generating certificates..."
./keycloak-ssl/scripts/generate-certs.sh

# Create truststore
echo "Creating truststore..."
./keycloak-ssl/scripts/create-truststore.sh

echo "Keycloak SSL setup completed!"
echo "You can now start Keycloak with: docker-compose up -d"