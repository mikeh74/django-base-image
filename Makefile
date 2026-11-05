# Variables
IMAGE_NAME ?= django-base-image
TAG ?= $(shell git rev-parse --short HEAD)
REGISTRY ?= ghcr.io/mikeh74

#.PHONY: all deps lint test build docker.build docker.push
.PHONY: docker.build docker.push

# all: deps lint test build

# deps:
# 	@echo "Installing dependencies..."
# 	# Example: npm install or go mod download
# 	npm install

# lint:
# 	@echo "Linting code..."
# 	# Example: eslint . or golangci-lint run
# 	npm run lint

# test:
# 	@echo "Running tests..."
# 	# Example: npm test or go test ./...
# 	npm test

# build:
# 	@echo "Building application..."
# 	# Example: Compiling a binary or building assets
# 	npm run build

docker.build:
	@echo "Building Docker image..."
	docker build -t $(REGISTRY)/$(IMAGE_NAME):$(TAG) .
	docker tag $(REGISTRY)/$(IMAGE_NAME):$(TAG) $(REGISTRY)/$(IMAGE_NAME):latest

docker.push:
	@echo "Pushing Docker image..."
	docker push $(REGISTRY)/$(IMAGE_NAME):$(TAG)
	docker push $(REGISTRY)/$(IMAGE_NAME):latest
