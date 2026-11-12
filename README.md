# Gaia Chat Application - Third Party Services Setup

This repository contains configuration files and setup instructions for third-party services used in the gaia-chat-app.

## Directory Structure

```
.
├── redis-ssl/           # Redis with SSL/TLS configuration
├── ibmmq/               # IBM MQ configuration
├── keycloak-ssl/        # Keycloak with SSL configuration
└── README.md            # This file
```

## Services Setup

### 1. Redis with SSL
Located in `redis-ssl/` directory:
- Docker Compose configuration for Redis with TLS support
- SSL certificate generation scripts
- Basic Redis configuration with authentication

### 2. IBM MQ
Located in `ibmmq/` directory:
- Docker Compose configuration for IBM MQ
- SSL configuration files
- Connection configuration referencing other components

### 3. Keycloak with SSL
Located in `keycloak-ssl/` directory:
- Docker Compose configuration for Keycloak with HTTPS
- SSL certificate generation scripts
- Realm configuration for chat application

## Getting Started

1. **Redis Setup:**
```bash
cd redis-ssl
# Follow instructions in redis-ssl/README.md
```

2. **IBM MQ Setup:**
```bash
cd ibmmq
# Follow instructions in ibmmq/README.md
```

3. **Keycloak Setup:**
```bash
cd keycloak-ssl
./scripts/generate-certs.sh
docker-compose up -d
```

## Security Notes

- SSL certificates in development environments are self-signed
- Production deployments should use valid SSL certificates from a trusted CA
- All services use default passwords for demonstration purposes only
- Configure appropriate security settings before production deployment

## References

This setup references components from:
- `src/connection.js` (Redis connection)
- `kafka/src/integration.js` (Kafka integration)
- Database configurations in `database/config.js`
