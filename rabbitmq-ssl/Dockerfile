FROM rabbitmq:3-management-alpine

# Copy certificate files
COPY rabbitmq-ssl/certs /etc/rabbitmq/certs

# Set proper permissions
RUN chmod 600 /etc/rabbitmq/certs/*.key && \
    chmod 644 /etc/rabbitmq/certs/*.crt && \
    chmod 644 /etc/rabbitmq/certs/ca.pem

# Copy configuration file
COPY rabbitmq-ssl/rabbitmq.conf /etc/rabbitmq/rabbitmq.conf

# Set configuration file as default
ENV RABBITMQ_CONFIG_FILE=/etc/rabbitmq/rabbitmq.conf