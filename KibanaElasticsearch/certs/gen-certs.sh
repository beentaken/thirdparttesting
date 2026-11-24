#!/bin/sh
set -e

CERT_DIR=/certs
cd "$CERT_DIR"

# Skip if certs already exist (keeps them stable across restarts)
if [ -f elasticsearch.crt ] && [ -f elasticsearch.key ] && [ -f ca.crt ]; then
  echo "Certificates already exist, skipping."
  exit 0
fi

echo "Generating CA..."
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out ca.key
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 \
  -subj "/CN=Elastic-Local-CA" -out ca.crt

echo "Generating Elasticsearch server certificate..."
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out elasticsearch.key
openssl req -new -key elasticsearch.key -subj "/CN=elasticsearch" -out elasticsearch.csr

cat > ext.cnf <<EOT
subjectAltName = DNS:elasticsearch,DNS:localhost,IP:127.0.0.1
extendedKeyUsage = serverAuth,clientAuth
EOT

openssl x509 -req -in elasticsearch.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out elasticsearch.crt -days 825 -sha256 -extfile ext.cnf

rm -f elasticsearch.csr ext.cnf ca.srl

# Elasticsearch runs as uid 1000, gid 0
chown -R 1000:0 "$CERT_DIR"
chmod 750 "$CERT_DIR"
chmod 640 *.key
chmod 644 *.crt

echo "Done:"
ls -l "$CERT_DIR"
