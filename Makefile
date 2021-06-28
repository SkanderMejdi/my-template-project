ID_USER = $(shell id -u)
ID_GROUP = $(shell id -g)
TARGET_TEST := site-api:dev
PHP_EXEC = ID_USER=$(ID_USER) ID_GROUP=$(ID_GROUP) docker-compose run --rm --user $(ID_USER):$(ID_GROUP) php
 
build:
	docker build -t $(TARGET_TEST) --target dev .

init:
	cp .env.dist .env

start:
	ID_USER=$(ID_USER) ID_GROUP=$(ID_GROUP) docker-compose up -d 

composer:
	$(PHP_EXEC) composer install
 
database:
	$(PHP_EXEC) bin/console doctrine:migrations:migrate

create-migration:
	$(PHP_EXEC) bin/console doctrine:migrations:generate

stop:
	ID_USER=$(ID_USER) ID_GROUP=$(ID_GROUP) docker-compose down --volumes --remove-orphans 

functional-test:
	docker-compose -f docker-compose.test.yml run --rm php ./wait-for postgres_test:5432 -- vendor/bin/behat -vv

unit-test:
	docker-compose -f docker-compose.test.yml run --rm php ./wait-for postgres_test:5432 -- vendor/bin/phpunit tests -v

test: functional-test unit-test

integration-functional-test:
	docker-compose -f docker-compose.integration.yml run --rm php ./wait-for postgres_test:5432 -- vendor/bin/behat -vvv

integration-unit-test:
	docker-compose -f docker-compose.integration.yml run --rm php ./wait-for postgres_test:5432 -- vendor/bin/phpunit tests -v
