FROM alpine:3.24.1
LABEL Maintainer="crossRT <crossRT@gmail.com>" \
  Description="Production-ready container image for Laravel"

# Install essential packages
RUN apk --no-cache add bash \
  gettext \
  nano \
  nginx \
  supervisor

# Install php related packages
RUN apk --no-cache add php85 \
  php85-bcmath \
  php85-ctype \
  php85-curl \
  php85-dev \
  php85-dom \
  php85-fileinfo \
  php85-fpm \
  php85-gd \
  php85-iconv \
  php85-intl \
  php85-json \
  php85-mbstring \
  php85-mysqli \
  php85-openssl \
  php85-pcntl \
  php85-pdo \
  php85-pdo_mysql \
  php85-pear \
  php85-pecl-redis \
  php85-phar \
  php85-posix \
  php85-session \
  php85-simplexml \
  php85-tokenizer \
  php85-xml \
  php85-xmlreader \
  php85-xmlwriter \
  php85-zip \
  php85-zlib

# Opcache install here
# because opcache doesn't have build for php8.5
RUN apk --no-cache add php84-opcache

# install curl
# curl is not installed from alpine package
# because the default curl binary 8.22 comes with alpine 3.24 is buggy
COPY --from=crossrt/alpine:3.24-with-curl-fix /usr/local/bin/curl /usr/local/bin/curl
COPY --from=crossrt/alpine:3.24-with-curl-fix /usr/local/lib/ /usr/local/lib/

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
COPY config/fpm-pool.conf /etc/php85/php-fpm.d/www.conf
COPY config/php.ini /etc/php85/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody:nobody /var/www/html && \
  chown -R nobody:nobody /run && \
  chown -R nobody:nobody /var/lib/nginx && \
  chown -R nobody:nobody /var/log/nginx && \
  chown -R nobody:nobody /var/log/php85/

RUN ln -sf /usr/bin/php85 /usr/bin/php
RUN ln -sf /usr/sbin/php-fpm85 /usr/sbin/php-fpm

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
