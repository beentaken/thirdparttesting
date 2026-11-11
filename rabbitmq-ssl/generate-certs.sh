#!/bin/bash

echo "Generating RabbitMQ SSL certificates..."

# Create directory structure
mkdir -p rabbitmq-ssl/certs
cd rabbitmq-ssl/certs

# Check if certificates already exist
if [ -f "ca.pem" ] && [ -f "rabbitmq.pem" ] && [ -f "rabbitmq-key.pem" ]; then
    echo "Certificates already exist. Skipping generation."
    exit 0
fi

# Generate CA certificate
echo "Generating CA certificate..."
openssl genrsa -out ca-key.pem 2048
openssl req -new -x509 -key ca-key.pem -out ca.pem -days 365 -subj "/C=US/ST=State/L=City/O=RabbitMQ/CN=ca.rabbitmq"

# Generate RabbitMQ server certificate
echo "Generating RabbitMQ server certificate..."
openssl genrsa -out rabbitmq-key.pem 2048
openssl req -new -key rabbitmq-key.pem -out rabbitmq-req.pem -subj "/C=US/ST=State/L=City/O=RabbitMQ/CN=rabbitmq"

# Sign the certificate with CA
echo "Signing certificate with CA..."
openssl x509 -req -in rabbitmq-req.pem -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out rabbitmq.pem -days 365

# Set proper permissions
chmod 600 rabbitmq-key.pem
chmod 644 rabbitmq.pem
chmod 644 ca.pem

echo "Certificates generated successfully!"
echo "Files created:"
ls -la