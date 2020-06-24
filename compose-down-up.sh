#!/bin/bash
docker-compose down && \
docker-compose up -d && \
docker-compose exec -u root app service ssh restart && \
docker-compose exec -u root app service supervisor start && \
docker-compose exec -u root app supervisorctl reread && \
docker-compose exec -u root app supervisorctl update && \
docker-compose exec -u root app supervisorctl start yourprojectname-worker:*
