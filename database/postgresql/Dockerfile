FROM postgres:18

LABEL maintainer="database-lab"
LABEL database="postgresql"

COPY init/ /docker-entrypoint-initdb.d/

EXPOSE 5432