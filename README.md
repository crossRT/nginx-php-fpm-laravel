# Docker image ready for Laravel

[TrafeX/docker-php-nginx](https://github.com/TrafeX/docker-php-nginx) is the origin of this repo. It's very minimal and has a very good performance of running php server. Most important thing is I have learn so many things from his setup <3.

Thus I decide to clone this repo and customize it further to suit for my laravel projects.

## Why use this image
* I have several laravel projects need to run on docker containers and I wish they could share the same image base, which suit for my needs.
* Origin repo doesn't installed with php extensions to run Laravel project.
* I like to use `bash` & `nano`
* I like to `envsub` to generate the `.env` when starting the container.

## What's included
* alpine 3.19.1
* nginx 1.24.0
* php-fpm 8.1.31
* php extensions to run laravel: php-pdo php-pdo_mysql php-tokenizer php-fileinfo
* linux binary I like to use: bash nano gettext
* alias ls='ls -lh' by default

## How to use
Kindly copy your laravel source code into `/var/www/html` with `nobody` user.

Nginx is already pointing the root directory to `/var/www/html/public`.

### example
```
FROM crossrt/nginx-php-fpm-laravel:latest

USER nobody
COPY --chown=nobody . /var/www/html
RUN rm -rf /var/www/html/.git/*
RUN rm -rf /var/www/html/.idea/*
RUN rm -rf /var/www/html/storage/logs/*
RUN rm -rf /var/www/html/storage/framework/cache/data/*
RUN rm -rf /var/www/html/storage/framework/views/*

# do your other stuff like add in the init.sh.
# which update your .env with container environments.
CMD /var/www/html/docker/init.sh
```

### Versions
|image tag| alpine | php | nginx | notes |
|--|--|--|--| -- |
|alpine3.18-php8.1-6|3.18.3|8.1.22|1.24.0| add dcron
|alpine3.18-php8.1-5|3.18.3|8.1.22|1.24.0| add php81-xmlwriter php81-zip php81-simplexml php81-iconv
|alpine3.18-php8.1-2|3.18.3|8.1.22|1.24.0| add php81-pcntl
|alpine3.18-php8.1|3.18.3|8.1.22|1.24.0|
|alpine3.13-php7.4|3.13.12|7.4.26|1.18.0|
