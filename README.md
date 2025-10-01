# Deploy

Deployment configuration for microservices using Docker Compose.

## 🚀 Quick Start

### 1. Клонировать репозиторий с субмодулями

```bash
git clone --recurse-submodules <repository-url>
cd deploy
```

Или если уже склонировали без субмодулей:

```bash
git submodule update --init --recursive
```

### 2. Создать .env файлы

Скопируйте example файлы и настройте по необходимости:

```bash
cd deploy/
cp .env.main.example .env.main
cp .env.gen1.example .env.gen1
cp .env.ml.example .env.ml
```

**Минимальные изменения (опционально):**
- По умолчанию всё работает "из коробки"
- Если нужно изменить порты или адреса - отредактируйте .env файлы

### 3. Собрать Docker образы

```bash
# Из корня проекта
make build

# Или напрямую
docker compose -f deploy/docker-compose.yaml build
```

### 4. Запустить сервисы

```bash
# Вариант 1: С выводом логов в терминал
make up

# Вариант 2: В фоне
make up-d

# Или напрямую
docker compose -f deploy/docker-compose.yaml up
```

## 📦 Архитектура

Проект состоит из 3 микросервисов:
- **gen-1** (`:8001-:8009`) - Генераторы данных с датчиков
- **main** (`:8000`) - Основной сервис, принимает данные
- **ml** (`:8010`) - ML сервис для анализа данных

## 📝 Makefile команды

```bash
make help       # Показать все доступные команды
make init       # Инициализация проекта (первый запуск)
make build      # Собрать все Docker образы
make up         # Запустить все сервисы
make up-d       # Запустить в фоне
make down       # Остановить все сервисы
make restart    # Перезапустить сервисы
make logs       # Показать логи всех сервисов
make logs-main  # Логи main сервиса
make logs-gen   # Логи gen-1 сервиса
make logs-ml    # Логи ml сервиса
make ps         # Статус сервисов
make clean      # Остановить и удалить всё
make rebuild    # Пересобрать и перезапустить
make update     # Обновить субмодули
```

## 🔧 Конфигурация

### Environment Variables

#### `.env.main` (Backend Main)
```bash
SERVER_ADDR=0.0.0.0           # Адрес сервера
SERVER_PORT=8000              # Порт сервера
ML_ADDR=ml                    # Адрес ML сервиса
ML_PORT=8000                  # Порт ML сервиса
SENSOR_IP_1=gen-1:8000        # IP первого датчика (опционально)
```

#### `.env.genX` (Generators)
```bash
SERVER_ADDR=0.0.0.0           # Адрес сервера
SERVER_PORT=8000              # Порт сервера
SENSOR_ID=<uuid>              # UUID датчика
SENSOR_TOKEN=<token>          # Токен датчика
WEBSOCKET_ADDR=main           # Адрес main сервиса
WEBSOCKET_PORT=8000           # Порт main сервиса
```

#### `.env.ml` (ML Service)
```bash
HOST=0.0.0.0                  # Адрес сервера
PORT=8000                     # Порт сервера
RELOAD=false                  # Auto-reload (dev only)
```

## 🔄 Обновление субмодулей

Когда микросервисы обновились в своих репозиториях:

```bash
# Обновить все субмодули
make update

# Или вручную
git submodule update --remote --merge

# Пересобрать образы
make rebuild
```

## 🐛 Troubleshooting

### Проверить статус контейнеров
```bash
make ps
# или
docker compose -f deploy/docker-compose.yaml ps
```

### Посмотреть логи
```bash
make logs           # Все сервисы
make logs-main      # Только main
make logs-gen       # Только generator
make logs-ml        # Только ML
```

### Полная перезагрузка
```bash
make clean    # Удалить всё
make build    # Пересобрать
make up-d     # Запустить
```

### Проверка health endpoints
```bash
curl http://localhost:8000/health      # Main service
curl http://localhost:8001/api/health  # Generator
curl http://localhost:8010/health      # ML service
```

## 📂 Структура проекта

```
deploy/
├── deploy/
│   ├── docker-compose.yaml       # Docker Compose конфигурация
│   ├── .env.main                 # Environment для main (не в git)
│   ├── .env.gen1                 # Environment для gen-1 (не в git)
│   ├── .env.ml                   # Environment для ml (не в git)
│   ├── .env.main.example         # Пример для main
│   ├── .env.gen1.example         # Пример для gen-1
│   └── .env.ml.example           # Пример для ml
├── services/                     # Субмодули (микросервисы)
│   ├── backend_gen/
│   ├── backend_main/
│   └── backend_ml/
├── Makefile                      # Команды для управления
└── README.md                     # Этот файл
```

## ⚙️ Требования

- Docker
- Docker Compose
- Git
- Make (опционально, но рекомендуется)
