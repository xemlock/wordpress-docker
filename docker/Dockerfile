FROM ubuntu:18.04

# Prevent 'debconf: unable to initialize frontend: Dialog' warnings
# https://github.com/phusion/baseimage-docker/issues/58
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install PHP
RUN apt-get update \
  && apt-get install -y \
    vim curl git \
    apache2 \
    php php-common php-dev php-zip php-curl php-gd php-mysql php-mbstring php-xml libapache2-mod-php \
    mysql-client \
  && rm -rf /var/lib/apt/lists/*

RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 128M/g" /etc/php/7.2/apache2/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 256M/g" /etc/php/7.2/apache2/php.ini

# Install Composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { echo 'Invalid Composer installer' . PHP_EOL; exit(1); }" \
  && php /tmp/composer-setup.php --install-dir="/usr/local/bin" --filename="composer" --no-ansi --force \
  && rm -f /tmp/composer-setup.php /tmp/composer-setup.sig

# Apache
COPY ./default.conf /etc/apache2/sites-available/000-default.conf
VOLUME ["/var/www"]

# AH00558: apache2: Could not reliably determine the server's fully qualified domain name
RUN sed -i -e 's/\(#ServerRoot \"\)/ServerName localhost\n\1/g' /etc/apache2/apache2.conf

RUN a2enmod rewrite

EXPOSE 80

COPY ./docker-entrypoint.sh /usr/local/bin/
COPY ./noop.php /

ENTRYPOINT ["docker-entrypoint.sh"]
