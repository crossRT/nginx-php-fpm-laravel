# Docker image ready for Laravel
---

[TrafeX/docker-php-nginx](https://github.com/TrafeX/docker-php-nginx) is the origin of this repo. It's very minimal and has a very good performance of running php server. Most important thing is I have learn so many things from his setup <3.

Thus I decide to clone this repo and customize it further to suit for my laravel projects.

## Why use this image
* I have several laravel projects need to run on docker containers and I wish they could share the same image base, which suit for my needs.
* Origin repo doesn't installed with php extensions to run Laravel project.
* I like to use `bash` & `nano`
* I like to `envsub` to generate the `.env` when starting the container.

## What's included
* alpine 3.23.5
* nginx 1.28.3-r4
* php-fpm 8.5.6
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
Each actively maintained alpine/php combination has its own Dockerfile under
`versions/<image-tag>/Dockerfile`, and the folder name is the docker image tag. All of them build with
the repo root as the build context, so they share the top-level `config/` files instead of duplicating
them. There is no separate revision suffix on the tag (no more `-1`, `-2`, ...) — a fix to a version is
just a commit to that folder's Dockerfile, and history lives in `git log`, not in the tag name.

Images are built and pushed to Docker Hub manually, per version, from the repo root:

```
# build
docker build --platform=linux/amd64 -f versions/alpine3.23-php8.5/Dockerfile -t crossrt/nginx-php-fpm-laravel:alpine3.23-php8.5 .

# push
docker push crossrt/nginx-php-fpm-laravel:alpine3.23-php8.5
```

|image tag| alpine | php | nginx | notes |
|--|--|--|--| -- |
|alpine3.24-php8.5|3.24.1|8.5.10|1.30.4-r1|
|alpine3.23-php8.5|3.23.5|8.5.6|1.28.3-r4|

Older tags (`alpine3.19-php8.3-3`, `alpine3.18-php8.1-*`, `alpine3.13-php7.4`, ...) are still available as
git tags from before this repo moved to the `versions/` folder layout, but are no longer maintained.
