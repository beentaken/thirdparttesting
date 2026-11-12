#!/bin/bash

echo "Creating Keycloak truststore..."

# Create directory if it doesn't exist
mkdir -p keycloak-ssl/certs

cd keycloak-ssl/certs

# Create a simple truststore with the CA certificate
keytool -importcert -file ca.crt -keystore truststore.jks -storepass changeit -noprompt -alias ca-keycloak

echo "Truststore created successfully!"