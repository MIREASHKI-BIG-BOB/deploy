.PHONY: help init build up down restart logs clean

help: ## Показать эту справку
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

init: ## Инициализация проекта (первый запуск)
	@echo "📦 Инициализация проекта..."
	git submodule update --init --recursive
	@if [ ! -f deploy/.env.main ]; then cp deploy/.env.main.example deploy/.env.main; echo "✅ Создан deploy/.env.main"; fi
	@if [ ! -f deploy/.env.gen1 ]; then cp deploy/.env.gen1.example deploy/.env.gen1; echo "✅ Создан deploy/.env.gen1"; fi
	@if [ ! -f deploy/.env.ml ]; then cp deploy/.env.ml.example deploy/.env.ml; echo "✅ Создан deploy/.env.ml"; fi
	@echo "✅ Проект инициализирован!"
	@echo ""
	@echo "⚙️  Отредактируйте .env файлы в deploy/ при необходимости"
	@echo "🚀 Затем запустите: make build && make up"

build: ## Собрать все Docker образы
	@echo "🔨 Сборка Docker образов..."
	docker compose -f deploy/docker-compose.yaml build

up: ## Запустить все сервисы
	@echo "🚀 Запуск сервисов..."
	docker compose -f deploy/docker-compose.yaml up

up-d: ## Запустить все сервисы в фоне
	@echo "🚀 Запуск сервисов в фоне..."
	docker compose -f deploy/docker-compose.yaml up -d

down: ## Остановить все сервисы
	@echo "🛑 Остановка сервисов..."
	docker compose -f deploy/docker-compose.yaml down

restart: ## Перезапустить все сервисы
	@echo "🔄 Перезапуск сервисов..."
	docker compose -f deploy/docker-compose.yaml restart

logs: ## Показать логи всех сервисов
	docker compose -f deploy/docker-compose.yaml logs -f

logs-main: ## Показать логи main сервиса
	docker compose -f deploy/docker-compose.yaml logs -f main

logs-gen: ## Показать логи gen-1 сервиса
	docker compose -f deploy/docker-compose.yaml logs -f gen-1

logs-ml: ## Показать логи ml сервиса
	docker compose -f deploy/docker-compose.yaml logs -f ml

ps: ## Показать статус сервисов
	docker compose -f deploy/docker-compose.yaml ps

clean: ## Остановить и удалить все контейнеры, сети, volumes
	@echo "🧹 Очистка..."
	docker compose -f deploy/docker-compose.yaml down -v
	docker system prune -f

rebuild: ## Пересобрать и перезапустить все сервисы
	@echo "🔨 Пересборка и перезапуск..."
	$(MAKE) down
	$(MAKE) build
	$(MAKE) up-d

update: ## Обновить все субмодули
	@echo "📥 Обновление субмодулей..."
	git submodule update --remote --merge
	@echo "✅ Субмодули обновлены"

