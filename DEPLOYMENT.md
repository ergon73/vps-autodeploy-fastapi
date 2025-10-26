# 🚀 Инструкции по деплою

## Предварительные требования

- Docker установлен локально
- VPS с настроенной инфраструктурой:
  - Traefik (реверс-прокси)
  - Docker Registry
  - Watchtower (автообновление)
  - Let's Encrypt сертификаты

## Быстрый старт

1. **Клонировать репозиторий:**
   ```bash
   git clone https://github.com/your-username/vps-autodeploy-fastapi.git
   cd vps-autodeploy-fastapi
   ```

2. **Настроить переменные в Makefile:**
   ```makefile
   REGISTRY_HOST = your-registry.com
   REGISTRY_USER = your-username
   REGISTRY_PASSWORD = your-password
   ```

3. **Собрать и отправить:**
   ```bash
   make bp
   ```

4. **Проверить работу:**
   - Registry: `https://your-registry.com/v2/_catalog`
   - Приложение: `https://your-app.com`

## Демонстрация

Проект демонстрирует:
- ✅ Полный цикл разработки
- ✅ Production-ready инфраструктуру
- ✅ Автоматический деплой
- ✅ Версионирование
- ✅ SSL сертификаты

## Полезные ссылки

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Docker Documentation](https://docs.docker.com/)
- [Traefik Documentation](https://doc.traefik.io/traefik/)
- [Let's Encrypt](https://letsencrypt.org/)
