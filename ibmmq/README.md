# IBM MQ Setup

This directory contains IBM MQ configuration files for the gaia-chat-app.

## Files

- `docker-compose.yml` - Docker Compose configuration for IBM MQ
- `mq-ssl.conf` - SSL configuration for IBM MQ
- `config.json` - Configuration file for connecting to IBM MQ

## Prerequisites

1. Docker and Docker Compose installed
2. Required environment variables set in `.env`

## Setup

1. Create a `.env` file with:
```
MQ_USERNAME=admin
MQ_PASSWORD=password
MQ_QMGR_NAME=QM1
MQ_SSL_KEYSTORE=/opt/mqm/qmgrs/QM1/ssl/key.kdb
MQ_SSL_TRUSTSTORE=/opt/mqm/qmgrs/QM1/ssl/trust.kdb
```

2. Run:
```bash
docker-compose up -d
```

## Testing

You can test the connection using:
```bash
docker exec -it ibmmq bash
# Then use mqsc commands or MQ client tools
```
