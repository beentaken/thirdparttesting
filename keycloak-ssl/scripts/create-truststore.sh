#!/bin/bash

# Create a truststore with the self-signed certificate
echo "Creating truststore..."

# First create a temporary keystore to import the certificate
keytool -genkey -keystore /tmp/temp-keystore.jks -storepass password -keypass password -dname "CN=localhost, OU=IT, O=Organization, L=City, S=State, C=US" -alias temp-key

# Import the certificate into a truststore
keytool -importcert \
  -file /opt/keycloak/conf/tls.crt \
  -keystore /opt/keycloak/conf/truststore.p12 \
  -storetype PKCS12 \
  -storepass password \
  -alias keycloak-cert \
  -noprompt

# Clean up
rm -f /tmp/temp-keystore.jks

echo "Truststore created successfully"
