FROM redis:7-alpine

# Create data directory
RUN mkdir -p /data

# Copy configuration file
COPY redis-ssl/redis.conf /etc/redis/redis.conf

# Copy certificates
COPY redis-ssl/certs /etc/redis/certs

# Set proper permissions on certificates
RUN chmod 600 /etc/redis/certs/*.key && \
    chmod 644 /etc/redis/certs/*.crt && \
    chmod 600 /etc/redis/certs/dh.pem

# Expose port
EXPOSE 6379

# Run Redis with our configuration
CMD ["redis-server", "/etc/redis/redis.conf"]