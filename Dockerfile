FROM alpine:3.19.1
LABEL Maintainer="crossRT <crossRT@gmail.com>" \
  Description="Docker image ready for Laravel"

# Install packages and remove default server definition
RUN apk --no-cache add php81 php81-fpm php81-opcache php81-mysqli php81-json php81-openssl php81-curl \
  php81-zlib php81-xml php81-phar php81-intl php81-dom php81-xmlreader php81-ctype php81-session php81-posix \
  php81-pdo php81-pdo_mysql php81-tokenizer php81-fileinfo bash nano gettext \
  php81-mbstring php81-gd php81-pcntl nginx supervisor curl \
  php81-xmlwriter php81-zip php81-simplexml php81-iconv \
  php81-dev php81-pear php81-pecl-redis php81-bcmath \
  gcc musl-dev make

# install dcron
RUN apk add --no-cache dcron libcap
RUN chown nobody:nobody /usr/sbin/crond
RUN setcap cap_setgid=ep /usr/sbin/crond
RUN chown -R nobody:nobody /var/spool/cron/crontabs/

# copy profile with some useful alias
COPY config/profile /.bashrc

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php81/php-fpm.d/www.conf
COPY config/php.ini /etc/php81/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx && \
  chown -R nobody.nobody /var/log/php81/

RUN ln -s /usr/bin/php81 /usr/bin/php

# Switch to use a non-root user from here on
USER nobody

# Add application
WORKDIR /var/www/html
COPY --chown=nobody src/ /var/www/html/public

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
