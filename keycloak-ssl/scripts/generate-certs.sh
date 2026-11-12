#!/bin/bash

echo "Generating Keycloak SSL certificates..."

# Create certificate directory
mkdir -p keycloak-ssl/certs

cd keycloak-ssl/certs

# Generate CA certificate
echo "Creating CA certificate..."
openssl genrsa -out ca.key 2048
openssl req -new -x509 -key ca.key -out ca.crt -days 365 -subj "/C=US/ST=State/L=City/O=Keycloak/CN=ca.keycloak"

# Generate server certificate
echo "Creating server certificate..."
openssl genrsa -out tls.key 2048
openssl req -new -key tls.key -out tls.csr -subj "/C=US/ST=State/L=City/O=Keycloak/CN=localhost"

# Sign the certificate with CA
echo "Signing server certificate..."
openssl x509 -req -in tls.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out tls.crt -days 365

# Create PKCS12 truststore for Keycloak
echo "Creating truststore..."
openssl pkcs12 -export -inkey tls.key -in tls.crt -out truststore.p12 -passout pass:changeit -name keycloak

# Set proper permissions
chmod 600 tls.key
chmod 644 tls.crt
chmod 644 ca.crt
chmod 600 truststore.p12

echo "Certificates generated successfully!"
echo "Files created:"
ls -la