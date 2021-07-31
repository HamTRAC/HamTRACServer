
DOCKER_REPO=ghcr.io/hamtrac
APP_NAME=hamtracserver

# grep the version from the mix file
VERSION=$(shell docker/version.sh)

# DOCKER TASKS
# Build the container
build: ## Build the container
	docker build --target production -t $(APP_NAME) .

build-nc: ## Build the container without caching
	docker build --no-cache --target production -t $(APP_NAME) .

build-dev: ## Build the container
	docker build --target develop -t $(APP_NAME):develop .

build-build: ## Build the container
	docker build --target builder -t $(APP_NAME):build .

run:
	docker run --rm $(APP_NAME)

run-dev: ## Run container on port configured in `config.env`
	docker run -v ${PWD}:/root/HamTRACServer -it --rm --name="$(APP_NAME)" $(APP_NAME):develop

release: build-nc publish

# Docker publish
publish: publish-latest # publish-version ## Publish the `{version}` ans `latest` tagged containers to ECR

publish-latest: tag-latest ## Publish the `latest` taged container to ECR
	@echo 'publish latest to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `{version}` taged container to ECR
	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` ans `latest` tags

tag-latest: ## Generate container `{version}` tag
	@echo 'create tag latest'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):latest

tag-version: ## Generate container `latest` tag
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):$(VERSION)
