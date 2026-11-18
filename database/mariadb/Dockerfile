FROM mariadb:11.4

LABEL maintainer="database-lab"
LABEL database="mariadb"

COPY init/ /docker-entrypoint-initdb.d/

EXPOSE 3306