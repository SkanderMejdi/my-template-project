FROM php:7.4.16-fpm-alpine3.13 as prod

RUN apk --update --no-cache add git postgresql-dev
RUN docker-php-ext-install pdo_pgsql

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY    composer.json composer.lock /var/www/
RUN composer install --no-dev --optimize-autoloader

COPY    symfony.lock /var/www/
COPY    src /var/www/src
COPY    config /var/www/config
COPY    public /var/www/public
COPY    bin /var/www/bin
COPY    migrations /var/www/migrations

CMD php-fpm
EXPOSE 9000

FROM prod as dev

COPY    behat.yml /var/www/
COPY    features /var/www/features
COPY    tests /var/www/tests

RUN composer install

COPY wait-for wait-for 
RUN chmod +x wait-for

CMD ./wait-for postgres:5432 -- php-fpm
