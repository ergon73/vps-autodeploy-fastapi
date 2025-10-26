# 🐳 Docker Hub Integration

## Обзор

Проект поддерживает публикацию образов в Docker Hub для публичного доступа и распространения.

## 🚀 Быстрый старт

### 1. Настройка Docker Hub

```bash
# Зарегистрируйтесь на https://hub.docker.com
# Создайте репозиторий: your-username/fastapi-test-app
```

### 2. Локальная публикация

```bash
# В папке проекта
make hub-deploy
```

### 3. Публикация через сервер

```bash
# SSH на сервер
ssh root@your-server-ip

# Запуск скрипта Docker Hub
/root/dockerhub-manager.sh deploy
```

## 📋 Команды Makefile

### Docker Hub команды:

```bash
make hub-login    # Вход в Docker Hub
make hub-push     # Публикация образа
make hub-deploy   # Сборка и публикация
make hub-info     # Информация о репозитории
```

### Локальный Registry команды:

```bash
make login        # Вход в локальный Registry
make build        # Сборка образа
make push         # Публикация в локальный Registry
make bp           # Сборка и публикация в локальный Registry
```

## 🔧 Конфигурация

### Переменные в Makefile:

```makefile
# Docker Hub настройки
DOCKERHUB_USER = your-dockerhub-username
DOCKERHUB_IMAGE = fastapi-test-app

# Локальный Registry настройки
REGISTRY_HOST = registry.your-domain.com
REGISTRY_USER = your-username
REGISTRY_PASSWORD = your-password
```

## 🌍 Преимущества Docker Hub

### Публичный доступ:
- ✅ Любой может скачать образ: `docker pull your-username/fastapi-test-app`
- ✅ Интеграция с CI/CD системами
- ✅ Автоматические сборки из GitHub

### Мониторинг:
- 📊 Статистика скачиваний
- 🏷️ Управление тегами и версиями
- 📝 Описания и документация

### Безопасность:
- 🔐 Приватные репозитории
- 🛡️ Сканирование уязвимостей
- 🔑 Управление доступом

## 🔄 Workflow

### Разработка → Публикация:

```bash
# 1. Разработка локально
make build

# 2. Тестирование
make run

# 3. Публикация в локальный Registry (автодеплой)
make bp

# 4. Публикация в Docker Hub (публичный доступ)
make hub-deploy
```

### Серверный скрипт:

```bash
# На сервере
/root/dockerhub-manager.sh deploy
```

## 📊 Мониторинг

### Проверка статуса:

```bash
# Локальный Registry
curl -k https://registry.your-domain.com/v2/_catalog

# Docker Hub
curl https://hub.docker.com/v2/repositories/your-username/fastapi-test-app/
```

### Логи публикации:

```bash
# Локальный Registry
docker logs registry

# Docker Hub (через скрипт)
/root/dockerhub-manager.sh logs
```

## 🛠️ Troubleshooting

### Проблема: Ошибка авторизации в Docker Hub

```bash
# Решение: Переавторизация
make hub-login
```

### Проблема: Образ не найден

```bash
# Проверка тегов
docker images | grep fastapi-test-app

# Пересборка
make build hub-push
```

### Проблема: Медленная публикация

```bash
# Использование локального Registry для быстрого деплоя
make bp

# Docker Hub для публичного доступа
make hub-deploy
```

## 🔗 Полезные ссылки

- **Docker Hub:** https://hub.docker.com/r/your-username/fastapi-test-app
- **Локальный Registry:** https://registry.your-domain.com/v2/_catalog
- **Docker Hub API:** https://docs.docker.com/docker-hub/api/
- **Docker CLI:** https://docs.docker.com/engine/reference/commandline/docker/

## 📝 Best Practices

### Тегирование:
- `latest` - последняя версия
- `1.0.1` - конкретная версия
- `dev` - версия для разработки

### Безопасность:
- Используйте приватные репозитории для чувствительных данных
- Регулярно обновляйте базовые образы
- Сканируйте образы на уязвимости

### Производительность:
- Используйте multi-stage builds
- Минимизируйте размер образа
- Кэшируйте слои Docker
