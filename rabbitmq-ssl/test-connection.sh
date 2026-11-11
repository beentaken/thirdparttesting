#!/bin/bash

echo "Testing RabbitMQ SSL connection..."

# Test connection using amqp protocol with SSL
echo "Testing AMQP over SSL..."
timeout 10s rabbitmqctl eval 'amqp_connection:info(self()).'

echo "Connection test completed."