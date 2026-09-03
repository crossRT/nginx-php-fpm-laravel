FROM alpine:3.24.1
LABEL Maintainer="crossRT <crossRT@gmail.com>" \
  Description="Docker image ready for Laravel"

# Install packages and remove default server definition
RUN apk --no-cache add php85 php85-fpm php84-opcache php85-mysqli php85-json php85-openssl php85-curl \
  php85-zlib php85-xml php85-phar php85-intl php85-dom php85-xmlreader php85-ctype php85-session php85-posix \
  php85-pdo php85-pdo_mysql php85-tokenizer php85-fileinfo bash nano gettext \
  php85-mbstring php85-gd php85-pcntl nginx supervisor curl \
  php85-xmlwriter php85-zip php85-simplexml php85-iconv \
  php85-dev php85-pear php85-pecl-redis php85-bcmath \
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
