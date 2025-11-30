<div align="center">

# 🚀 FastAPI Auto-Deploy VPS

[![Python](https://img.shields.io/badge/Python-3.11+-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.104+-009688?logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Production](https://img.shields.io/badge/Status-Production%20Ready-success)](https://github.com/ergon73/vps-autodeploy-fastapi)

**Production-ready FastAPI приложение с автоматическим деплоем на VPS**

[Особенности](#-особенности) • [Быстрый старт](#-быстрый-старт) • [Документация](#-документация) • [Архитектура](#-архитектура)

</div>

---

## 🎯 О проекте

Полноценное решение для автоматического развертывания FastAPI приложения на VPS с нулевым временем простоя (zero-downtime deployment). Проект демонстрирует современные DevOps практики и production-ready инфраструктуру.

### 💡 Почему этот проект?

- ⚡ **Zero-downtime deployment** — обновления без остановки сервиса
- 🔒 **Автоматический HTTPS** — Let's Encrypt сертификаты из коробки
- 🐳 **Полная контейнеризация** — Docker + Docker Registry
- 🔄 **Auto-update** — Watchtower следит за новыми версиями
- 📦 **Версионирование** — поддержка множественных версий образов
- 🛡️ **Security-first** — best practices безопасности

## ✨ Особенности

### 🏗️ Технологический стек

| Компонент | Технология | Назначение |
|-----------|------------|------------|
| **Backend** | FastAPI 0.104+ | Современный async веб-фреймворк |
| **Контейнеризация** | Docker | Изоляция и портируемость |
| **Reverse Proxy** | Traefik 2.10 | Автоматический HTTPS и маршрутизация |
| **SSL** | Let's Encrypt | Бесплатные SSL сертификаты |
| **Registry** | Docker Registry | Приватное хранилище образов |
| **Auto-update** | Watchtower | Автоматическое обновление контейнеров |
| **CI/CD** | Makefile | Автоматизация деплоя |

### 🎨 Ключевые возможности

- 🚀 **Одна команда для деплоя** — `make bp` и всё готово
- 📊 **REST API** — готовые endpoints с документацией
- 📝 **Auto-documentation** — Swagger UI + ReDoc из коробки
- 🔍 **Health checks** — мониторинг состояния приложения
- 🔄 **Rolling updates** — обновления без простоя
- 🏷️ **Semantic versioning** — управление версиями
- 🌐 **Multi-domain** — поддержка нескольких доменов

---

## ⚡ Быстрый старт

### Локальный запуск (за 30 секунд)

```bash
# Клонировать репозиторий
git clone https://github.com/ergon73/vps-autodeploy-fastapi.git
cd vps-autodeploy-fastapi

# Установить зависимости
pip install -r requirements.txt

# Запустить приложение
python main.py
```

Откройте http://localhost:8000 — приложение работает! 🎉

### Docker запуск

```bash
# Собрать и запустить
docker build -t fastapi-app .
docker run -p 8000:8000 fastapi-app
```

### Production деплой на VPS

```bash
# 1. Настроить окружение
cp env.example .env
nano .env  # укажите свои данные

# 2. Задеплоить одной командой
make bp  # build + push

# 3. Watchtower автоматически обновит приложение на сервере (~30 сек)
```

---

## 📸 Демонстрация

### API Endpoints

```bash
# Главная страница
curl https://app.your-domain.com/

# Информация о приложении
curl https://app.your-domain.com/info

# Версия
curl https://app.your-domain.com/version

# Health check
curl https://app.your-domain.com/health
```

### Swagger UI Documentation

Откройте `/docs` для интерактивной API документации с возможностью тестирования endpoints.

---

**Перед использованием замените все шаблонные значения на свои реальные данные!**

### 🔐 Настройка окружения

1. **Скопируйте файл с шаблонными настройками:**
   ```bash
   cp env.example .env
   ```

2. **Отредактируйте .env файл с вашими данными:**
   ```bash
   nano .env
   ```

3. **Обновите Makefile:**
   ```makefile
   # Configuration (ЗАМЕНИТЕ НА СВОИ ДАННЫЕ!)
   REGISTRY_HOST = registry.your-domain.com
   REGISTRY_USER = your-username  
   REGISTRY_PASSWORD = your-password
   IMAGE_NAME = fastapi-test-app
   APP_VERSION = 1.0.1
   ```

4. **Настройте DNS записи:**
   - `app.your-domain.com` → IP вашего сервера
   - `registry.your-domain.com` → IP вашего сервера

### 🚫 Что НЕ коммитить в Git:
- Реальные пароли и токены
- Файлы `.env` с реальными данными
- SSL сертификаты и ключи
- Конфигурационные файлы с секретами

---

## 📚 Документация

| Документ | Описание |
|----------|----------|
| **[ARCHITECTURE.md](ARCHITECTURE.md)** | 🏗️ Детальная архитектура и схема инфраструктуры |
| **[DEPLOYMENT.md](DEPLOYMENT.md)** | 🚀 Пошаговые инструкции по развертыванию |
| **[OPERATIONS.md](OPERATIONS.md)** | ⚙️ Команды управления и troubleshooting |
| **[DOCKER-HUB.md](DOCKER-HUB.md)** | 🐳 Интеграция с Docker Hub |

---

## 🏗️ Архитектура

```
┌─────────────────────────────────────────────────────────┐
│                    Internet                              │
│   ┌──────────────────────────────────────────────┐      │
│   │  DNS: app.your-domain.com                    │      │
│   │       registry.your-domain.com               │      │
│   └───────────────────┬──────────────────────────┘      │
│                       │                                  │
│                       ▼                                  │
│   ┌──────────────────────────────────────────────┐      │
│   │         VPS Server (Ubuntu 22.04)            │      │
│   │                                               │      │
│   │  ┌─────────────────────────────────────┐    │      │
│   │  │   Traefik (Reverse Proxy)           │    │      │
│   │  │   • Automatic HTTPS                  │    │      │
│   │  │   • Let's Encrypt                    │    │      │
│   │  └────────┬──────────────┬──────────────┘    │      │
│   │           │              │                    │      │
│   │           ▼              ▼                    │      │
│   │  ┌──────────────┐  ┌──────────────┐         │      │
│   │  │ FastAPI App  │  │   Registry   │         │      │
│   │  │ :8000        │  │ :5000        │         │      │
│   │  └──────┬───────┘  └──────────────┘         │      │
│   │         │                                     │      │
│   │         ▼                                     │      │
│   │  ┌──────────────────────────────┐           │      │
│   │  │   Watchtower                 │           │      │
│   │  │   • Auto-update containers   │           │      │
│   │  │   • Pull new images          │           │      │
│   │  └──────────────────────────────┘           │      │
│   │                                               │      │
│   │  Docker Network: traefik-network             │      │
│   └───────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────┘
```

---

## 📊 API Endpoints

| Endpoint | Метод | Описание |
|----------|-------|----------|
| `/` | GET | Главная страница с информацией о приложении |
| `/health` | GET | Health check для мониторинга |
| `/info` | GET | Детальная информация о системе |
| `/version` | GET | Текущая версия приложения |
| `/changelog` | GET | История изменений |
| `/current-date` | GET | Текущая дата и время сервера |
| `/docs` | GET | Swagger UI документация |
| `/redoc` | GET | ReDoc документация |

---

## ⚠️ Настройка безопасности

**Перед использованием замените все шаблонные значения на свои реальные данные!**

### 🔐 Настройка окружения

1. **Скопируйте файл с шаблонными настройками:**
   ```bash
   cp env.example .env
   ```

2. **Отредактируйте .env файл с вашими данными:**
   ```bash
   nano .env
   ```

3. **Обновите Makefile:**
   ```makefile
   # Configuration (ЗАМЕНИТЕ НА СВОИ ДАННЫЕ!)
   REGISTRY_HOST = registry.your-domain.com
   REGISTRY_USER = your-username  
   REGISTRY_PASSWORD = your-password
   IMAGE_NAME = fastapi-test-app
   APP_VERSION = 1.0.1
   ```

4. **Настройте DNS записи:**
   - `app.your-domain.com` → IP вашего сервера
   - `registry.your-domain.com` → IP вашего сервера

### 🚫 Что НЕ коммитить в Git:
- Реальные пароли и токены
- Файлы `.env` с реальными данными
- SSL сертификаты и ключи
- Конфигурационные файлы с секретами

---

## 🔧 Makefile команды

```bash
# Основные команды
make help           # Показать все доступные команды
make build          # Собрать Docker образ
make push           # Отправить образ в Registry
make bp             # Build + Push (основная команда для деплоя)

# Управление версиями
make bump-patch     # Увеличить patch версию (1.0.0 → 1.0.1)
make bump-minor     # Увеличить minor версию (1.0.0 → 1.1.0)
make bump-major     # Увеличить major версию (1.0.0 → 2.0.0)

# Локальная разработка
make run            # Запустить локально
make stop           # Остановить локальный контейнер
make logs           # Показать логи

# Проверка
make check-deploy   # Проверить статус деплоя
```

---

## 📝 Разработка

### Добавление новых endpoints

```python
@app.get("/new-endpoint")
async def new_endpoint():
    return {"message": "New endpoint"}
```

### Workflow разработки

```bash
# 1. Внести изменения в код
nano main.py

# 2. Увеличить версию
make bump-patch

# 3. Задеплоить
make bp

# 4. Подождать ~30 секунд (Watchtower обновит автоматически)

# 5. Проверить
curl https://app.your-domain.com/version
```

---

## 🔍 Мониторинг и логи

```bash
# Проверить версии в Registry
curl -k -u your-username:your-password \
  https://registry.your-domain.com/v2/fastapi-test-app/tags/list

# Локальные логи
make logs

# Логи на сервере
ssh your-server "docker logs -f fastapi-app"

# Проверить статус
make check-deploy
```

---

## 🛡️ Безопасность

| Компонент | Реализация |
|-----------|------------|
| **HTTPS** | Let's Encrypt автоматические сертификаты |
| **TLS** | 1.2+ only, современные cipher suites |
| **Headers** | Security headers через Traefik |
| **Container** | Непривилегированный пользователь |
| **Firewall** | UFW, только порты 22, 80, 443 |
| **Secrets** | .env файлы не в Git |
| **Registry** | HTTP Basic Auth |

---

## ⚡ Производительность

- **Response time:** ~50-200ms
- **Container restart:** ~2-3 секунды
- **Deployment time:** ~30 секунд
- **Downtime:** 0 секунд (zero-downtime)
- **SSL handshake:** ~100ms

---

## 🆘 Troubleshooting

<details>
<summary><b>Проблема: Не удается авторизоваться в Registry</b></summary>

```bash
# Проверить доступность Registry
curl -k https://registry.your-domain.com/v2/

# Проверить учетные данные
make login
```
</details>

<details>
<summary><b>Проблема: Образ не обновляется</b></summary>

```bash
# Проверить логи Watchtower
docker logs watchtower -f

# Принудительное обновление
docker compose pull && docker compose up -d
```
</details>

<details>
<summary><b>Проблема: Приложение недоступно</b></summary>

```bash
# Проверить статус контейнеров
docker ps

# Проверить логи приложения
docker logs fastapi-app

# Проверить логи Traefik
docker logs traefik
```
</details>

---

## 🎯 Что демонстрирует проект

✅ **DevOps практики:**
- Полный CI/CD пайплайн
- Infrastructure as Code
- Zero-downtime deployment
- Версионирование образов

✅ **Production-ready решение:**
- Автоматический HTTPS
- Мониторинг и логирование
- Health checks
- Безопасность

✅ **Современный стек:**
- FastAPI (async Python)
- Docker ecosystem
- Reverse proxy (Traefik)
- Автоматизация (Makefile)

---

## 📜 Changelog

### v1.0.1 (2024-10-26)
- ✅ Добавлен endpoint `/changelog`
- ✅ Обновлена информация о версии
- ✅ Демонстрация множественных версий в Registry
- ✅ Улучшена документация

### v1.0.0 (2024-10-25)
- ✅ Первоначальный релиз
- ✅ Базовые endpoints
- ✅ Docker контейнеризация
- ✅ Автодеплой на VPS

---

## 🤝 Контрибьюция

Проект открыт для улучшений! Если вы нашли баг или хотите добавить функционал:

1. Fork проекта
2. Создайте feature branch (`git checkout -b feature/amazing-feature`)
3. Commit изменений (`git commit -m 'Add amazing feature'`)
4. Push в branch (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

---

## 📬 Контакты

**Георгий Белянин**
- GitHub: [@ergon73](https://github.com/ergon73)
- Telegram: [@Ergon73](https://t.me/Ergon73)

---

## 📄 Лицензия

MIT License - смотрите [LICENSE](LICENSE) для деталей

---

<div align="center">

**Сделано с ❤️ для демонстрации современных DevOps практик**

⭐ Поставьте звезду, если проект был полезен!

</div>
