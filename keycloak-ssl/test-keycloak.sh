#!/bin/bash

echo "Testing Keycloak SSL connection..."

# Wait for Keycloak to start
echo "Waiting for Keycloak to start..."
sleep 10

# Test HTTPS connection
echo "Testing HTTPS connection..."
curl -k https://localhost:8443/

if [ $? -eq 0 ]; then
    echo "Keycloak SSL connection test PASSED"
else
    echo "Keycloak SSL connection test FAILED"
fi

# Test Keycloak admin API
echo "Testing Keycloak admin API..."
curl -k https://localhost:8443/admin/

if [ $? -eq 0 ]; then
    echo "Keycloak admin API test PASSED"
else
    echo "Keycloak admin API test FAILED"
fi