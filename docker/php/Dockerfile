FROM php:8.4-fpm

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN apt-get -y update
RUN apt-get -y install git
RUN apt-get -y install unzip

RUN curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer.phar \
        --install-dir=/usr/local/bin && \
        mv /usr/local/bin/composer.phar /usr/local/bin/composer

ARG CURRENT_UID=1000
ARG CURRENT_GID=1000

RUN echo $CURRENT_GID;
RUN echo $CURRENT_UID;

RUN addgroup --gid $CURRENT_GID worker || true
RUN adduser --shell /bin/bash --disabled-login --gid $CURRENT_GID --uid $CURRENT_UID worker
RUN mkdir -p /home/worker/.config/psysh && chown -R worker /home/worker/

