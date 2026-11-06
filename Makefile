# Variables
IMAGE_NAME ?= django-base-image
TAG ?= $(shell git rev-parse --short HEAD)
REGISTRY ?= ghcr.io/mikeh74

#.PHONY: all deps lint test build docker.build docker.push
.PHONY: docker.build docker.push

docker.build:
	@echo "Building Docker image..."
	docker build -t $(REGISTRY)/$(IMAGE_NAME):$(TAG) .
	docker tag $(REGISTRY)/$(IMAGE_NAME):$(TAG) $(REGISTRY)/$(IMAGE_NAME):latest

docker.push:
	@echo "Pushing Docker image..."
	docker push $(REGISTRY)/$(IMAGE_NAME):$(TAG)
	docker push $(REGISTRY)/$(IMAGE_NAME):latest
