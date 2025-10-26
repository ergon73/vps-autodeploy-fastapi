# 🔧 Команды управления и мониторинга

## 📊 Мониторинг

### Статус системы
```bash
# Статус контейнеров
docker ps

# Логи всех сервисов
docker compose logs -f

# Логи конкретного сервиса
docker logs traefik -f
docker logs registry -f
docker logs watchtower -f
docker logs fastapi-app -f

# Использование ресурсов
docker stats

# Статус сертификатов
certbot certificates
```

### Проверка работы
```bash
# Registry
curl -u your-username:your-password https://registry.your-domain.com/v2/_catalog

# FastAPI Application
curl -k https://app.your-domain.com

# Проверка Watchtower
docker logs watchtower --tail 10
```

---

## ⚙️ Управление

### Перезапуск сервисов
```bash
# Перезапуск всех сервисов
cd /root/autodeploy
docker compose restart

# Перезапуск конкретного сервиса
docker compose restart fastapi-app

# Полная перезагрузка
docker compose down
docker compose up -d

# Обновление образов
docker compose pull
docker compose up -d
```

### Backup
```bash
# Backup registry data
tar -czf registry-backup-$(date +%Y%m%d).tar.gz /root/autodeploy/registry-data/

# Backup configs
tar -czf config-backup-$(date +%Y%m%d).tar.gz \
  /root/autodeploy/traefik/ \
  /root/autodeploy/auth/ \
  /root/autodeploy/docker-compose.yml
```

---

## 🚀 Troubleshooting

### Проблема: Сертификат не получается
**Решение:**
```bash
# Проверить DNS
nslookup registry.your-domain.com

# Проверить порты
ufw status

# Попробовать снова
certbot certonly --standalone -d registry.your-domain.com --force-renewal
```

### Проблема: Traefik не стартует
**Решение:**
```bash
# Проверить логи
docker logs traefik

# Проверить конфигурацию
docker run --rm -v $(pwd)/traefik:/etc/traefik \
  traefik:v2.10 traefik validate --configFile=/etc/traefik/traefik.yml
```

### Проблема: Watchtower не обновляет
**Решение:**
```bash
# Проверить метки контейнера
docker inspect fastapi-app | grep -A10 Labels

# Проверить логи
docker logs watchtower -f

# Проверить авторизацию в Registry
docker exec watchtower cat /config.json
```

### Проблема: Registry недоступен
**Решение:**
```bash
# Проверить контейнер
docker ps | grep registry

# Проверить labels
docker inspect registry | grep -A30 Labels

# Проверить логи Traefik
docker logs traefik | grep registry

# Тест напрямую
curl -v http://localhost:5000/v2/
```

---

## 🔍 Диагностика

### Проверка DNS
```bash
# Локально
nslookup registry.your-domain.com
nslookup app.your-domain.com

# Или через dig
dig registry.your-domain.com +short
dig app.your-domain.com +short

# Должны вернуть: YOUR_SERVER_IP
```

### Тест SSL
```bash
# Проверка SSL сертификата
openssl s_client -connect app.your-domain.com:443 -servername app.your-domain.com

# Проверка сертификата
echo | openssl s_client -servername app.your-domain.com \
  -connect app.your-domain.com:443 2>/dev/null | \
  openssl x509 -noout -dates
```

### Мониторинг трафика
```bash
# Статистика контейнеров
docker stats --no-stream

# Проверка портов
netstat -tulpn | grep -E ':(80|443)'

# Проверка процессов
ps aux | grep docker
```

---

## 📚 Полезные команды

### Docker
```bash
# Очистка неиспользуемых образов
docker image prune -f

# Очистка всех неиспользуемых ресурсов
docker system prune -f

# Просмотр образов
docker images

# Просмотр volumes
docker volume ls

# Просмотр сетей
docker network ls
```

### Система
```bash
# Использование диска
df -h

# Использование памяти
free -h

# Загрузка системы
uptime

# Активные соединения
ss -tuln
```

### Логи
```bash
# Системные логи
journalctl -u docker

# Логи сервисов
systemctl status docker
systemctl status certbot.timer

# Логи Traefik
docker logs traefik --tail 50 -f
```

---

**Создано:** 26 октября 2025  
**Автор:** Georgy Belyanin  
**Email:** georgy.belyanin@gmail.com
