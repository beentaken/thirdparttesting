FROM mongo:8

LABEL maintainer="database-lab"
LABEL database="mongodb"

COPY init/ /docker-entrypoint-initdb.d/

EXPOSE 27017