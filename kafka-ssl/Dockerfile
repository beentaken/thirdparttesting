# Cert generator image: creates a CA, broker cert and client cert with OpenSSL
FROM alpine:3.20

# openjdk jre provides keytool (used to build the PKCS12 truststore)
RUN apk add --no-cache openssl bash openjdk17-jre-headless

COPY generate-certs.sh /usr/local/bin/generate-certs.sh
RUN chmod +x /usr/local/bin/generate-certs.sh

VOLUME /certs
ENTRYPOINT ["/usr/local/bin/generate-certs.sh"]
