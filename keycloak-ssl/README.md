# Keycloak SSL Setup

This directory contains the configuration for running Keycloak with HTTPS/SSL.

## Files

- `docker-compose.yml` - Docker Compose configuration for Keycloak with SSL
- `scripts/generate-certs.sh` - Script to generate self-signed certificates
- `certs/` - Directory containing SSL certificates (tls.crt, tls.key)

## Setup

1. Generate certificates:
```bash
./scripts/generate-certs.sh
```

2. Start Keycloak:
```bash
docker-compose up -d
```

3. Access Keycloak at: https://localhost:8443

## Configuration

Keycloak will be configured with:
- Admin username: admin
- Admin password: admin
- HTTPS enabled on port 8443
- PostgreSQL database for persistence

## Notes

- The certificates are self-signed and intended for development/testing only
- For production use, replace the self-signed certificates with valid SSL certificates
- The Keycloak database will persist in a Docker volume

## Testing

To test the connection:
```bash
curl -k https://localhost:8443
```
