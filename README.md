# Third Party Services Setup

This repository contains configuration files and scripts to set up various third-party services including Keycloak, PostgreSQL, Redis, and Kafka.

## Services Included

### 1. Keycloak
- **Version**: 24.0.4 (Quarkus-based)
- **Database**: PostgreSQL 13.23.0
- **Port**: 8443 (HTTPS)
- **Admin Credentials**: admin / admin

### 2. PostgreSQL
- **Version**: 13.23.0
- **Port**: 5432
- **Database**: keycloak
- **User**: keycloak
- **Password**: password

## Setup Instructions

### Prerequisites
- Docker and Docker Compose installed
- OpenSSL (for certificate generation)

### Keycloak Setup
```bash
# Navigate to Keycloak directory
cd keycloak-ssl

# Make setup script executable and run it
chmod +x setup-keycloak.sh
./setup-keycloak.sh
```

### Manual Certificate Generation (if needed)
```bash
# Generate certificates manually
mkdir -p certs
openssl genrsa -out certs/tls.key 2048
openssl req -new -x509 -key certs/tls.key -out certs/tls.crt -days 365 -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
chmod 600 certs/tls.key
chmod 644 certs/tls.crt
```

### Start Services
```bash
# Start all services using docker-compose
docker-compose up -d

# View logs
docker-compose logs -f
```

## Keycloak Configuration Notes

- The setup handles database version compatibility issues with PostgreSQL 13.23.0
- HTTPS is enabled by default
- Realm import is configured automatically
- Database version check has been disabled to prevent compatibility errors

## Troubleshooting

### Database Version Issues
The setup now includes proper configuration to handle PostgreSQL 13.23.0:
```yaml
QUARKUS_HIBERNATE_ORM_DATABASE_VERSION_CHECK_ENABLED: "false"
```

### Certificate Issues
If certificate issues occur, regenerate certificates:
```bash
rm -rf certs/*
./scripts/generate-certs.sh
```

### Docker Image Issues
If you encounter image resolution problems:
```bash
docker pull quay.io/keycloak/keycloak:24.0.4
docker pull postgres:13.23.0
```

## Access Information

- **Keycloak Admin Console**: https://localhost:8443
- **PostgreSQL**: localhost:5432
- **Admin User**: admin
- **Admin Password**: admin

## Security Note

This setup is intended for development and testing purposes only. Do not use these configurations in production without proper security hardening.
