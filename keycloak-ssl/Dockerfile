FROM quay.io/keycloak/keycloak:latest

ENV KC_HTTP_ENABLED=true

ENV KC_HTTPS_CERTIFICATE_FILE=/opt/keycloak/conf/certs/tls.crt
ENV KC_HTTPS_CERTIFICATE_KEY_FILE=/opt/keycloak/conf/certs/tls.key

CMD ["start-dev"]