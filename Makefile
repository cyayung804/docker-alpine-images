# Makefile for docker-alpine-images

.PHONY: help install update build


help:
	@echo "Makefile for docker-alpine-images"
	@echo ""
	@echo "Usage:"
	@echo "  make install             - Install dependencies"
	@echo "  make update image=<src>  - Update image tags"
	@echo "  make build               - Build and push"


install:
	@chmod +x src/install.sh
	@bash src/install.sh


update:
	@chmod +x src/update.sh
	@bash src/update.sh $(image)


build:
	@chmod +x src/build.sh
	@bash src/build.sh $(image)

build_all:
	@chmod +x src/build_all.sh
	@bash src/build_all.sh $(image)
