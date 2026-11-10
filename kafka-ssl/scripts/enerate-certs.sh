#!/usr/bin/env bash
set -euo pipefail

CERTS_DIR=${CERTS_DIR:-/opt/kafka-certs}
CA_PASS=${CA_PASS:-capassword}
BROKER_PASS=${BROKER_PASS:-brokerpass}
TRUST_PASS=${TRUST_PASS:-trustpass}
CLIENT_PASS=${CLIENT_PASS:-clientpass}
BROKER_CN=${BROKER_CN:-kafka-broker}
BROKER_SAN=${BROKER_SAN:-"DNS:localhost,DNS:kafka-broker,IP:127.0.0.1"}

mkdir -p "$CERTS_DIR"
cd "$CERTS_DIR"

# ---- 1. CA ----
if [[ ! -f ca-cert ]]; then
  echo ">>> Generating CA"
  openssl req -new -x509 -keyout ca-key -out ca-cert -days 3650 \
    -subj "/CN=Kafka-CA/OU=Kafka/O=MyOrg/L=City/ST=State/C=US" \
    -passout pass:"$CA_PASS"
fi

# ---- 2. Broker key + CSR ----
echo ">>> Generating broker key + CSR"
openssl genrsa -out kafka-server.key 2048
openssl req -new -key kafka-server.key -out kafka-server.csr \
  -subj "/CN=${BROKER_CN}/OU=Kafka/O=MyOrg/L=City/ST=State/C=US"

# ---- 3. SAN ----
cat > san.cnf <<EOF
subjectAltName=${BROKER_SAN}
EOF

# ---- 4. Sign broker cert ----
echo ">>> Signing broker cert"
openssl x509 -req -CA ca-cert -CAkey ca-key -in kafka-server.csr \
  -out kafka-server.crt -days 365 -CAcreateserial \
  -extfile san.cnf -passin pass:"$CA_PASS"

# ---- 5. Broker PKCS12 -> JKS ----
echo ">>> Building broker keystore"
openssl pkcs12 -export -in kafka-server.crt -inkey kafka-server.key \
  -certfile ca-cert -name kafka-broker \
  -out kafka-server.p12 -passout pass:"$BROKER_PASS"

keytool -importkeystore -noprompt \
  -srckeystore kafka-server.p12 -srcstoretype PKCS12 -srcstorepass "$BROKER_PASS" \
  -destkeystore kafka.server.keystore.jks -deststoretype JKS \
  -deststorepass "$BROKER_PASS" -destkeypass "$BROKER_PASS"

# ---- 6. Truststore ----
echo ">>> Building truststore"
rm -f kafka.server.truststore.jks
keytool -keystore kafka.server.truststore.jks -alias CARoot \
  -import -file ca-cert -storepass "$TRUST_PASS" -noprompt

# ---- 7. Optional client keystore (for mTLS) ----
if [[ "${GENERATE_CLIENT_CERT:-false}" == "true" ]]; then
  echo ">>> Generating client cert"
  openssl genrsa -out client.key 2048
  openssl req -new -key client.key -out client.csr \
    -subj "/CN=kafka-client/OU=Kafka/O=MyOrg/L=City/ST=State/C=US"
  openssl x509 -req -CA ca-cert -CAkey ca-key -in client.csr \
    -out client.crt -days 365 -CAcreateserial -passin pass:"$CA_PASS"

  openssl pkcs12 -export -in client.crt -inkey client.key \
    -certfile ca-cert -name kafka-client \
    -out client.p12 -passout pass:"$CLIENT_PASS"

  keytool -importkeystore -noprompt \
    -srckeystore client.p12 -srcstoretype PKCS12 -srcstorepass "$CLIENT_PASS" \
    -destkeystore client.keystore.jks -deststoretype JKS \
    -deststorepass "$CLIENT_PASS" -destkeypass "$CLIENT_PASS"

  rm -f client.truststore.jks
  keytool -keystore client.truststore.jks -alias CARoot \
    -import -file ca-cert -storepass "$TRUST_PASS" -noprompt
fi

echo ">>> Certificates generated in $CERTS_DIR"
ls -1 "$CERTS_DIR"