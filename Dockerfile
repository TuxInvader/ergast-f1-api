FROM nginx/unit:1.14.0-php7.3
RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    debconf-utils && \
    echo mariadb-server mysql-server/root_password password ergastf1 | debconf-set-selections && \
    echo mariadb-server mysql-server/root_password_again password ergastf1 | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    mariadb-server \
    php-mysql \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY webroot /var/www/html
COPY ergastdb/data/f1db.sql.gz /

RUN chown www-data:www-data -R /var/www/html

RUN service mysql start && \
    sleep 3 && \
    mysql -uroot -pergastf1 -e "CREATE USER ergast@localhost IDENTIFIED BY 'f1RuleZ';CREATE DATABASE ergastdb;GRANT ALL privileges ON ergastdb.* TO 'ergast'@localhost;" && \
    zcat /f1db.sql.gz | mysql -uroot -pergastf1 ergastdb

EXPOSE 80

COPY main.sh /

ENTRYPOINT ["/main.sh"]

