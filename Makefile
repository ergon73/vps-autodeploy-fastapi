# ============================================
# FastAPI Test App - Makefile
# ============================================

# Configuration (ЗАМЕНИТЕ НА СВОИ ДАННЫЕ!)
REGISTRY_HOST = registry.your-domain.com
REGISTRY_USER = your-username
REGISTRY_PASSWORD = your-password
IMAGE_NAME = fastapi-test-app
APP_VERSION = 1.0.1

# Docker Hub настройки
DOCKERHUB_USER = your-dockerhub-username
DOCKERHUB_IMAGE = fastapi-test-app

# Colors for output (disabled for Windows compatibility)
RED = 
GREEN = 
YELLOW = 
BLUE = 
NC = 

# ============================================
# Targets
# ============================================

.PHONY: help login build tag push bp run stop clean test lint format

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "=================================="
	@echo "FastAPI Test App - Makefile"
	@echo "=================================="
	@echo ""
	@echo "Available commands:"
	@echo "  make login  - Login to Docker Registry"
	@echo "  make build  - Build Docker image"
	@echo "  make push   - Push image to Registry"
	@echo "  make bp     - Build and Push (main deployment command)"
	@echo "  make run    - Run application locally"
	@echo "  make stop   - Stop local container"
	@echo "  make clean  - Clean up unused images"
	@echo ""
	@echo "Docker Hub commands:"
	@echo "  make hub-login - Login to Docker Hub"
	@echo "  make hub-push  - Push image to Docker Hub"
	@echo "  make hub-deploy - Build and push to Docker Hub"
	@echo ""
	@echo "Configuration:"
	@echo "  REGISTRY_HOST    = $(REGISTRY_HOST)"
	@echo "  REGISTRY_USER     = $(REGISTRY_USER)"
	@echo "  IMAGE_NAME       = $(IMAGE_NAME)"
	@echo "  APP_VERSION      = $(APP_VERSION)"
	@echo ""
	@echo "⚠️  ВАЖНО: Замените шаблонные значения на свои!"
	@echo ""

login: ## Login to Docker Registry
	@echo "$(BLUE)🔐 Logging in to Docker Registry...$(NC)"
	@docker login $(REGISTRY_HOST) -u $(REGISTRY_USER) -p $(REGISTRY_PASSWORD)
	@echo "$(GREEN)✅ Login successful!$(NC)"

build: ## Build Docker image
	@echo "$(BLUE)🔨 Building Docker image...$(NC)"
	@docker build \
		--build-arg VERSION=$(APP_VERSION) \
		-t $(REGISTRY_HOST)/$(IMAGE_NAME):$(APP_VERSION) \
		-t $(REGISTRY_HOST)/$(IMAGE_NAME):latest \
		.
	@echo "$(GREEN)✅ Image built successfully!$(NC)"

tag: build ## Create additional tags
	@echo "$(BLUE)🏷️  Creating tags...$(NC)"
	@docker tag $(REGISTRY_HOST)/$(IMAGE_NAME):$(APP_VERSION) \
		$(REGISTRY_HOST)/$(IMAGE_NAME):latest
	@echo "$(GREEN)✅ Tags created!$(NC)"

push: login ## Push image to Registry
	@echo "$(BLUE)📤 Pushing image to Registry...$(NC)"
	@docker push $(REGISTRY_HOST)/$(IMAGE_NAME):$(APP_VERSION)
	@docker push $(REGISTRY_HOST)/$(IMAGE_NAME):latest
	@echo "$(GREEN)✅ Image pushed successfully!$(NC)"
	@echo ""
	@echo "$(GREEN)Image available at:$(NC)"
	@echo "  $(REGISTRY_HOST)/$(IMAGE_NAME):$(APP_VERSION)"
	@echo "  $(REGISTRY_HOST)/$(IMAGE_NAME):latest"
	@echo ""

bp: build push ## Build and Push (main deployment command)
	@echo ""
	@echo "$(GREEN)🚀 Build and Push completed!$(NC)"
	@echo "$(YELLOW)⏳ Application will auto-update on server in ~30 seconds$(NC)"
	@echo ""

run: ## Run application locally
	@echo "$(BLUE)🚀 Starting application locally...$(NC)"
	@docker run -d \
		--name $(IMAGE_NAME)-local \
		-p 8000:8000 \
		--restart unless-stopped \
		$(REGISTRY_HOST)/$(IMAGE_NAME):latest
	@echo "$(GREEN)✅ Application started!$(NC)"
	@echo "$(YELLOW)📍 Available at: http://localhost:8000$(NC)"

stop: ## Stop local container
	@echo "$(BLUE)🛑 Stopping application...$(NC)"
	@docker stop $(IMAGE_NAME)-local 2>/dev/null || true
	@docker rm $(IMAGE_NAME)-local 2>/dev/null || true
	@echo "$(GREEN)✅ Application stopped!$(NC)"

clean: ## Clean up unused images
	@echo "$(BLUE)🧹 Cleaning up unused images...$(NC)"
	@docker image prune -f
	@echo "$(GREEN)✅ Cleanup completed!$(NC)"

test: ## Run tests (if available)
	@echo "$(BLUE)🧪 Running tests...$(NC)"
	@docker run --rm $(REGISTRY_HOST)/$(IMAGE_NAME):latest \
		python -m pytest tests/ -v
	@echo "$(GREEN)✅ Tests completed!$(NC)"

lint: ## Run linter
	@echo "$(BLUE)🔍 Running linter...$(NC)"
	@docker run --rm $(REGISTRY_HOST)/$(IMAGE_NAME):latest \
		flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
	@echo "$(GREEN)✅ Linting completed!$(NC)"

format: ## Format code
	@echo "$(BLUE)💅 Formatting code...$(NC)"
	@black .
	@isort .
	@echo "$(GREEN)✅ Formatting completed!$(NC)"

logs: ## Show application logs (local)
	@docker logs -f $(IMAGE_NAME)-local

shell: ## Open shell in container
	@docker exec -it $(IMAGE_NAME)-local /bin/bash

inspect: ## Inspect image
	@docker inspect $(REGISTRY_HOST)/$(IMAGE_NAME):latest

size: ## Show image size
	@docker images $(REGISTRY_HOST)/$(IMAGE_NAME)

version: ## Show current version
	@echo "$(GREEN)Current version: $(APP_VERSION)$(NC)"

bump-patch: ## Bump patch version (1.0.0 -> 1.0.1)
	@$(eval NEW_VERSION := $(shell echo $(APP_VERSION) | awk -F. '{$$3 = $$3 + 1;} 1' OFS=.))
	@sed -i 's/APP_VERSION = .*/APP_VERSION = $(NEW_VERSION)/' Makefile
	@echo "$(GREEN)Version bumped to $(NEW_VERSION)$(NC)"

bump-minor: ## Bump minor version (1.0.0 -> 1.1.0)
	@$(eval NEW_VERSION := $(shell echo $(APP_VERSION) | awk -F. '{$$2 = $$2 + 1; $$3 = 0;} 1' OFS=.))
	@sed -i 's/APP_VERSION = .*/APP_VERSION = $(NEW_VERSION)/' Makefile
	@echo "$(GREEN)Version bumped to $(NEW_VERSION)$(NC)"

bump-major: ## Bump major version (1.0.0 -> 2.0.0)
	@$(eval NEW_VERSION := $(shell echo $(APP_VERSION) | awk -F. '{$$1 = $$1 + 1; $$2 = 0; $$3 = 0;} 1' OFS=.))
	@sed -i 's/APP_VERSION = .*/APP_VERSION = $(NEW_VERSION)/' Makefile
	@echo "$(GREEN)Version bumped to $(NEW_VERSION)$(NC)"

# ============================================
# Advanced targets
# ============================================

full-deploy: bump-patch bp ## Bump version and deploy

watch-logs: ## Watch server logs (requires SSH config)
	@echo "$(BLUE)📊 Watching server logs...$(NC)"
	@ssh vps-prompt "cd /root/autodeploy && docker logs -f fastapi-app"

check-deploy: ## Check deployment status on server
	@echo "$(BLUE)🔍 Checking deployment status...$(NC)"
	@ssh vps-prompt "cd /root/autodeploy && docker ps && docker compose logs --tail 20"

server-shell: ## Open shell on server
	@ssh vps-prompt

# ============================================
# Docker Hub commands
# ============================================

hub-login: ## Login to Docker Hub
	@echo "$(BLUE)🔐 Logging in to Docker Hub...$(NC)"
	@docker login -u $(DOCKERHUB_USER)
	@echo "$(GREEN)✅ Docker Hub login successful!$(NC)"

hub-push: hub-login ## Push image to Docker Hub
	@echo "$(BLUE)📤 Pushing image to Docker Hub...$(NC)"
	@docker tag $(IMAGE_NAME):latest $(DOCKERHUB_USER)/$(DOCKERHUB_IMAGE):latest
	@docker tag $(IMAGE_NAME):latest $(DOCKERHUB_USER)/$(DOCKERHUB_IMAGE):$(APP_VERSION)
	@docker push $(DOCKERHUB_USER)/$(DOCKERHUB_IMAGE):latest
	@docker push $(DOCKERHUB_USER)/$(DOCKERHUB_IMAGE):$(APP_VERSION)
	@echo "$(GREEN)✅ Image pushed to Docker Hub successfully!$(NC)"
	@echo ""
	@echo "$(GREEN)Image available at:$(NC)"
	@echo "  https://hub.docker.com/r/$(DOCKERHUB_USER)/$(DOCKERHUB_IMAGE)"
	@echo ""

hub-deploy: build hub-push ## Build and push to Docker Hub
	@echo ""
	@echo "$(GREEN)🚀 Docker Hub deployment completed!$(NC)"
	@echo "$(YELLOW)📦 Image published to: https://hub.docker.com/r/$(DOCKERHUB_USER)/$(DOCKERHUB_IMAGE)$(NC)"
	@echo ""

hub-info: ## Show Docker Hub information
	@echo "$(GREEN)Docker Hub Repository:$(NC)"
	@echo "  https://hub.docker.com/r/$(DOCKERHUB_USER)/$(DOCKERHUB_IMAGE)"
	@echo ""
	@echo "$(GREEN)Available tags:$(NC)"
	@echo "  latest, $(APP_VERSION)"
