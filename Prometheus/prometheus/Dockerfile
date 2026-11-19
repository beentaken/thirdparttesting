FROM prom/prometheus:latest

COPY --chown=nobody:nobody --chmod=644 prometheus.yml /etc/prometheus/prometheus.yml
COPY --chown=nobody:nobody --chmod=644 web.yml /etc/prometheus/web.yml

CMD ["--config.file=/etc/prometheus/prometheus.yml", \
     "--web.config.file=/etc/prometheus/web.yml", \
     "--storage.tsdb.path=/prometheus", \
     "--web.listen-address=:9090"]