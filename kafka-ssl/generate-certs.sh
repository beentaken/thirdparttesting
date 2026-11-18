#!/usr/bin/env bash
set -euo pipefail

CERT_DIR="${CERT_DIR:-/certs}"
PASS="${CERT_PASSWORD:-changeit}"
DAYS="${CERT_DAYS:-365}"
BROKER_HOST="${BROKER_HOST:-kafka}"

mkdir -p "$CERT_DIR"
cd "$CERT_DIR"

# credential files expected by the Kafka image (always (re)written)
for f in keystore_creds key_creds truststore_creds; do
  printf '%s' "$PASS" > "$f"
  chmod 644 "$f"
done

if [[ -f ca.pem && -f kafka.keystore.p12 && -f kafdrop.keystore.p12 && -f kafka.truststore.p12 ]]; then
  echo "Certificates already exist in $CERT_DIR - skipping."
  exit 0
fi

echo ">> Generating CA"
openssl req -new -x509 -nodes -newkey rsa:4096 -days "$DAYS" \
  -keyout ca.key -out ca.pem -subj "/CN=Local-Kafka-CA/O=Dev"

echo ">> Generating broker certificate (SAN: $BROKER_HOST, localhost)"
cat > broker.ext <<EXT
subjectAltName = DNS:${BROKER_HOST}, DNS:localhost, IP:127.0.0.1
extendedKeyUsage = serverAuth, clientAuth
EXT
openssl req -new -nodes -newkey rsa:2048 \
  -keyout kafka.key -out kafka.csr -subj "/CN=${BROKER_HOST}/O=Dev"
openssl x509 -req -in kafka.csr -CA ca.pem -CAkey ca.key -CAcreateserial \
  -out kafka.pem -days "$DAYS" -sha256 -extfile broker.ext
openssl pkcs12 -export -in kafka.pem -inkey kafka.key -certfile ca.pem \
  -name kafka -out kafka.keystore.p12 -passout "pass:${PASS}"

echo ">> Generating Kafdrop client certificate"
cat > client.ext <<EXT
extendedKeyUsage = clientAuth
EXT
openssl req -new -nodes -newkey rsa:2048 \
  -keyout kafdrop.key -out kafdrop.csr -subj "/CN=kafdrop/O=Dev"
openssl x509 -req -in kafdrop.csr -CA ca.pem -CAkey ca.key -CAcreateserial \
  -out kafdrop.pem -days "$DAYS" -sha256 -extfile client.ext
openssl pkcs12 -export -in kafdrop.pem -inkey kafdrop.key -certfile ca.pem \
  -name kafdrop -out kafdrop.keystore.p12 -passout "pass:${PASS}"

echo ">> Building PKCS12 truststore (for the Kafka broker)"
keytool -importcert -noprompt -alias local-ca -file ca.pem \
  -keystore kafka.truststore.p12 -storetype PKCS12 -storepass "$PASS"

echo ">> Writing Kafdrop client properties"
cat > kafdrop.properties <<PROPS
security.protocol=SSL
ssl.truststore.type=PEM
ssl.truststore.location=${CERT_DIR}/ca.pem
ssl.keystore.type=PKCS12
ssl.keystore.location=${CERT_DIR}/kafdrop.keystore.p12
ssl.keystore.password=${PASS}
ssl.endpoint.identification.algorithm=https
PROPS

# cleanup + make readable by non-root users in the kafka/kafdrop containers (dev only)
rm -f *.csr *.ext *.srl
chmod 644 ./*.pem ./*.p12 ./*.properties ./*.key

echo ">> Done:"
ls -l "$CERT_DIR"
