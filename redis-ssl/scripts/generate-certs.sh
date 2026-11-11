#!/bin/bash

# Create certificates directory if it doesn't exist
mkdir -p redis-ssl/certs

# Generate CA key and certificate
openssl genrsa -out redis-ssl/certs/ca.key 4096
openssl req -new -x509 -key redis-ssl/certs/ca.key -out redis-ssl/certs/ca.crt -days 3650 -subj "/C=US/ST=California/L=San Francisco/O=Redis/CN=Redis CA"

# Generate server key
openssl genrsa -out redis-ssl/certs/redis.key 2048

# Generate server certificate signing request
openssl req -new -key redis-ssl/certs/redis.key -out redis-ssl/certs/redis.csr -subj "/C=US/ST=California/L=San Francisco/O=Redis/CN=localhost"

# Sign the server certificate with CA
openssl x509 -req -in redis-ssl/certs/redis.csr -CA redis-ssl/certs/ca.crt -CAkey redis-ssl/certs/ca.key -CAcreateserial -out redis-ssl/certs/redis.crt -days 365 -extensions v3_req -extfile <(cat <<EOF
[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = redis
IP.1 = 127.0.0.1
EOF
)

# Generate DH parameters (for better security)
openssl dhparam -out redis-ssl/certs/dh.pem 2048

# Set proper permissions
chmod 600 redis-ssl/certs/*.key
chmod 644 redis-ssl/certs/*.crt
chmod 600 redis-ssl/certs/dh.pem

echo "Certificates generated successfully!"
echo "Files created:"
ls -la redis-ssl/certs/