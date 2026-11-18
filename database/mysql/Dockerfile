FROM mysql:8.4

LABEL maintainer="database-lab"
LABEL database="mysql"

COPY init/ /docker-entrypoint-initdb.d/

EXPOSE 3306