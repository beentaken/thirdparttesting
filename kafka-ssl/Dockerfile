FROM apache/kafka:3.9.1

USER root

# UBI minimal/micro doesn't ship microdnf reliably — check and use what's there
RUN set -eux; \
    if command -v microdnf >/dev/null 2>&1; then \
        microdnf install -y openssl tar gzip bash procps-ng findutils; \
        microdnf clean all; \
    elif command -v dnf >/dev/null 2>&1; then \
        dnf install -y openssl tar gzip bash procps-ng findutils; \
        dnf clean all; \
    elif command -v yum >/dev/null 2>&1; then \
        yum install -y openssl tar gzip bash procps-ng findutils; \
        yum clean all; \
    else \
        echo "No package manager found — using preinstalled tools only"; \
    fi; \
    command -v openssl; command -v tar; command -v bash