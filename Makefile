
define \n


endef

# OS ———————————————————————————————————————————————————————————————————————————
OS := $(shell uname)
CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)
# Arguments ————————————————————————————————————————————————————————————————————
branch=
dump=

# Setup ————————————————————————————————————————————————————————————————————————
WORKDIR=/var/www/html

DOCKER_BIN 				= docker
DOCKER_COMPOSE_BIN		= docker compose

DOCKER_COMPOSE			= CURRENT_UID=$(CURRENT_UID) CURRENT_GID=$(CURRENT_GID) ${DOCKER_COMPOSE_BIN}
PHP_CONTAINER_NAME		= php
CONTAINER_EXEC			= ${DOCKER_COMPOSE_BIN} exec ${PHP_CONTAINER_NAME}

EXEC_PHP				= $(DOCKER_COMPOSE) exec -T --workdir=$(WORKDIR) php
YII					= $(EXEC_PHP) yii
COMPOSER				= $(EXEC_PHP) composer
GIT						= git

php: ## Заходим в контейнер php
	@${DOCKER_COMPOSE} exec php bash --login

install: build  start	migrate ## Установка проекта

reinstall: kill install ## Удаление контейнеров и полная пересборка проекта

.PHONY: php install reinstall update test


.PHONY: up

up:	$(info ${\n}----> Запускаем проект)
	${DOCKER_COMPOSE} --profile dev up -d --remove-orphans --no-recreate

down:	$(info ${\n}----> Останавливаем проект)
	${DOCKER_COMPOSE} --profile dev down

restart: stop start; ## Перезапуск контейнеров

status:  ## Получаем статус контейнеров
	$(info ${\n}----> Статус контейнеров приложения)
	@${DOCKER_COMPOSE} ps

status_kafka:
	$(info ${\n}----> Статус контейнеров кафки)
	@${DOCKER_COMPOSE_KAFKA} ps

build: stop  ## Сборка контейнеров
	$(info ${\n}----> Сборка контейнеров)
	@$(DOCKER_COMPOSE) down; \
	$(DOCKER_COMPOSE) pull --ignore-pull-failures; \
	$(DOCKER_COMPOSE) build --pull --parallel

kill: ## Удаление docker контейнеров, образов и томов
	$(info ${\n}----> Принудительное завершение, удаление docker контейнеров, образов и томов)
	@$(DOCKER_COMPOSE) kill; \
	$(DOCKER_COMPOSE) down --rmi all -v --remove-orphans

clear_cache: ## Принудительная очистка файлового кеша
	$(info ${\n}----> Очищаем кеш)
	${EXEC_PHP} rm -rf var/cache/*

.PHONY: start stop build restart status clear_cache

migrate: vendor ## Выполнение миграций до последней доступной версии
	$(info ${\n}----> Миграция базы данных)
	@$(YII) doctrine:migrations:migrate --no-interaction --allow-no-migration; \

.PHONY: migrate

vendor: composer.lock
	$(info ${\n}----> Установка зависимостей)
	$(COMPOSER) install
