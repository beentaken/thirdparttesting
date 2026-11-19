# Prometheus with TLS (OpenSSL cert generator container)

    docker compose up -d --build

- `certgen` creates a local CA + server cert in the `certs` volume, then exits.
- `prometheus` starts afterwards with TLS enabled on :9090.

Test (extract the CA first):

    docker run --rm -v prometheus-tls_certs:/certs alpine cat /certs/ca.crt > ca.crt
    curl --cacert ca.crt https://localhost:9090/-/healthy

Regenerate certs: `docker compose down -v && docker compose up -d --build`

Self-signed certs are for dev/test; use a real CA for production.
