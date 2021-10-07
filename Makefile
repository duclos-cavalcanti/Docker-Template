SHELL := /bin/bash
FILE := $(lastword $(MAKEFILE_LIST))

TAG := foo-template
REPO := foo-ubuntu-20.04
NAME := foo-example

exist-docker-image = $(shell docker image ls | grep ${TAG} | tr -s ' ' | cut -f2 -d ' ')
exist-docker-running = $(shell docker ps -a | grep ${TAG} | tr -s ' ' | cut -f2 -d ' ')

all: 

.PHONY: help
help: 
	$(info Toolchain version: placeholder)
	$(info)
	$(info Targets: )
	$(info  * build         - Builds docker image with NAME:${NAME} and TAG:${TAG})
	$(info  * run       	- Run the built docker, should be called after build)
	$(info  * clean       	- Deletes Running Docker)
	$(info  * clean-img     - Deletes built Docker Image)
	$(info  * reset     	- Cleans environemnt, deleting docker image and running version of it)
	@echo ""

.PHONY: build
build:
	@echo "## Building Docker ##"
	@docker build . -t ${TAG}:${REPO}

.PHONY: run
run: $(if $(call exist-docker-image),,build)
	@echo "## Running Docker ##"
	@docker run --name ${NAME} \
				-p 8080:8080 \
				-it ${TAG}:${REPO}

.PHONY: clean
clean:
	@echo "## Removing Docker ##"
	@if [ -n $(call exist-docker-running) ]; then \
		docker rm ${NAME}; \
	fi

.PHONY: clean-img
clean-img:
	@echo "## Removing Docker Image ##"
	@if [ -n $(call exist-docker-image) ]; then \
		docker rmi $(shell docker images --filter=reference="*foo*" -q); \
	fi

.PHONY: reset
reset: clean clean-img
	@echo "## Finished Resetting Docker Environment ##"
