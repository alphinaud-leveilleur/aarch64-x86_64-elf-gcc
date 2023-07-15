NAME=gcc-cross-x86_64-elf
DOCKERREG=kirk1701a
TAG=latest
IMAGE=$(DOCKERREG)/$(NAME):$(TAG)

.PHONY: build
build:
	docker build . -t $(IMAGE)
