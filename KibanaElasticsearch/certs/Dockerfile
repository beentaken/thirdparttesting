FROM alpine:3.20

RUN apk add --no-cache openssl

COPY gen-certs.sh /usr/local/bin/gen-certs.sh
# Strip Windows line endings and make executable
RUN sed -i 's/\r$//' /usr/local/bin/gen-certs.sh && \
    chmod +x /usr/local/bin/gen-certs.sh

ENTRYPOINT ["/usr/local/bin/gen-certs.sh"]
