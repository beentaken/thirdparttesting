FROM eclipse-mosquitto:2

USER root
RUN apk add --no-cache openssl

COPY mosquitto.conf /mosquitto/config/mosquitto.conf
COPY entrypoint.sh /entrypoint.sh
# strip Windows CRLF line endings and make executable
RUN sed -i 's/\r$//' /entrypoint.sh /mosquitto/config/mosquitto.conf \
    && chmod +x /entrypoint.sh

EXPOSE 8883
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]
