
FROM alpine:3.22

RUN apk add --no-cache openssl

WORKDIR /certs

COPY generate-cert.sh /usr/local/bin/generate-cert.sh

RUN chmod +x /usr/local/bin/generate-cert.sh

ENTRYPOINT ["/usr/local/bin/generate-cert.sh"]
