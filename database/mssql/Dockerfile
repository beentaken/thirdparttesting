FROM mysql:8.4

LABEL maintainer="database-dev"

COPY ./init/ /docker-entrypoint-initdb.d/

EXPOSE 3306