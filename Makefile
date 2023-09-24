-include .env

SHELL = bash

PROJECT_ENV ?=
ifeq ($(PROJECT_ENV),)
    $(error PROJECT_ENV is not defined)
endif

PROJECT_NAME ?=
ifeq ($(PROJECT_NAME),)
    $(error PROJECT_NAME is not defined)
endif

PROJECT_DATA ?=
ifeq ($(PROJECT_DATA),)
    $(error PROJECT_DATA is not defined)
endif

default: up

up:
ifeq ($(wildcard $(PROJECT_DATA)),)
	$(error PROJECT_DATA not exists)
endif
	docker-compose up -d --build --remove-orphans --force-recreate
.PHONY: up

down:
	docker-compose down --remove-orphans --volumes
.PHONY: down

logs:
	docker-compose logs -f --tail 50
.PHONY: logs

setup:
ifneq ($(PROJECT_ENV),local)
	$(error the target permitted in local environment only)
endif
	-docker network create --driver=bridge --attachable --internal=false ingress
	mkdir -p $(PROJECT_DATA)
	touch $(PROJECT_DATA)/acme.json
	chmod 600 $(PROJECT_DATA)/acme.json
.PHONY: setup