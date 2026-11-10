#!/usr/bin/env bash
set -euo pipefail

CERTS_DIR=${CERTS_DIR:-/opt/kafka-certs}

if [[ ! -f "$CERTS_DIR/kafka.server.keystore.jks" ]]; then
  echo ">>> No keystore found — generating certificates"
  /opt/scripts/generate-certs.sh
else
  echo ">>> Existing keystore found — skipping cert generation"
fi

# Format storage (KRaft) or use ZK — here we use ZooKeeper-less KRaft for simplicity is not configured,
# so we keep classic path with embedded ZK disabled. Adjust if you want KRaft.
echo ">>> Starting Kafka"
exec /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties