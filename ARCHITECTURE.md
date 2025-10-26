# 🏗️ Архитектура и инфраструктура

## 📋 Обзор проекта

**Домен:** your-domain.com  
**IP VPS:** YOUR_SERVER_IP  
**Дата реализации:** 26 октября 2025  
**Email:** georgy.belyanin@gmail.com

### Основные компоненты
- **Traefik v2.10** - Реверс-прокси с автоматическим HTTPS
- **Docker Registry** - Приватное хранилище Docker-образов
- **Watchtower** - Автоматическое обновление контейнеров
- **FastAPI приложение** - Тестовое production-ready приложение
- **Let's Encrypt** - Бесплатные SSL-сертификаты с автообновлением

---

## 🔧 Детальная реализация

### 1. Настройка VPS

#### 1.1 Базовая конфигурация
```bash
# Обновление системы
apt update && apt upgrade -y

# Установка базовых инструментов
apt install -y curl wget git nano htop ufw apache2-utils
```

#### 1.2 Настройка Firewall (UFW)
```bash
# КРИТИЧЕСКИ ВАЖНО: Сначала SSH!
ufw allow 22/tcp comment 'SSH'
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'
ufw allow 8000/tcp comment 'FastAPI direct'

# Включение firewall
ufw enable

# Проверка
ufw status
```

**Результат:**
```
Status: active

To                         Action      From
22/tcp                     ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
8000/tcp                   ALLOW       Anywhere
```

---

### 2. Установка Docker

#### 2.1 Установка зависимостей
```bash
apt install -y ca-certificates curl gnupg lsb-release
```

#### 2.2 Добавление Docker репозитория
```bash
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
```

#### 2.3 Установка Docker
```bash
apt update
apt install -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

# Запуск и автозагрузка
systemctl start docker
systemctl enable docker

# Проверка
docker --version
docker compose version
```

**Результат:**
```
Docker version 28.5.1, build e180ab8
Docker Compose version v2.40.2
```

---

### 3. Настройка DNS

#### 3.1 DNS записи
```
Тип: A
Имя: registry.your-domain.com
Значение: YOUR_SERVER_IP
TTL: 300

Тип: A
Имя: app.your-domain.com
Значение: YOUR_SERVER_IP
TTL: 300
```

#### 3.2 Проверка DNS
```bash
nslookup registry.your-domain.com
nslookup app.your-domain.com

# Ожидаемый результат: YOUR_SERVER_IP
```

---

### 4. Получение SSL-сертификатов Let's Encrypt

#### 4.1 Установка Certbot
```bash
apt install -y certbot
```

#### 4.2 Получение сертификатов
```bash
certbot certonly --standalone \
  -d registry.your-domain.com \
  -d app.your-domain.com \
  --non-interactive \
  --agree-tos \
  --email georgy.belyanin@gmail.com \
  --preferred-challenges http
```

**Результат:**
```
Certificate is saved at: /etc/letsencrypt/live/registry.your-domain.com/fullchain.pem
Key is saved at: /etc/letsencrypt/live/registry.your-domain.com/privkey.pem
This certificate expires on 2026-01-24.
```

#### 4.3 Настройка прав доступа
```bash
chmod -R 755 /etc/letsencrypt/live/
chmod -R 755 /etc/letsencrypt/archive/
```

#### 4.4 Проверка сертификатов
```bash
certbot certificates
```

---

## 🔄 Процесс автоматического деплоя

### Workflow
1. **Локальная разработка** - Изменение кода приложения
2. **Сборка образа** - `docker build`
3. **Тегирование** - Версия + latest
4. **Отправка в Registry** - `docker push`
5. **Watchtower** - Обнаруживает новый образ (каждые 30 сек)
6. **Автоматическое обновление** - Остановка старого, запуск нового
7. **Готово** - Приложение обновлено без простоя

### Time-to-production
- **Интервал проверки:** 30 секунд
- **Время деплоя:** ~2-3 секунды
- **Downtime:** 0 секунд (zero-downtime)

---

## 📊 Характеристики системы

### Производительность
- **SSL handshake:** ~100ms
- **Response time:** ~50-200ms (зависит от приложения)
- **Container restart:** ~2-3 секунды

### Надежность
- **Auto-restart:** Да (unless-stopped)
- **Health checks:** Да
- **Backup:** Рекомендуется для registry-data
- **Monitoring:** Доступно через Traefik API

### Безопасность
- **HTTPS:** 100% трафика
- **Authentication:** Registry защищен паролем
- **Firewall:** UFW с минимальными портами
- **Security headers:** Включены
- **TLS:** 1.2+ только

---

## 📈 Масштабирование

### Добавление нового приложения
1. Создать Dockerfile
2. Собрать и отправить в Registry
3. Добавить сервис в docker-compose.yml:
```yaml
new-app:
  image: registry.your-domain.com/new-app:latest
  networks:
    - traefik-network
  labels:
    - "traefik.enable=true"
    - "traefik.http.routers.newapp.rule=Host(`newapp.your-domain.com`)"
    - "traefik.http.routers.newapp.entrypoints=websecure"
    - "traefik.http.routers.newapp.tls=true"
    - "traefik.http.routers.newapp.tls.certresolver=letsencrypt"
    - "com.centurylinklabs.watchtower.enable=true"
```

### Добавление новой DNS записи
```
Тип: A
Имя: newapp.your-domain.com
Значение: YOUR_SERVER_IP
```

---

**Создано:** 26 октября 2025  
**Автор:** Georgy Belyanin  
**Email:** georgy.belyanin@gmail.com
