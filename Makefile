# Makefile for Dockerized Rails App

# Build production image with secret master.key
build:
	DOCKER_BUILDKIT=1 docker build \
	  --secret id=master_key,src=config/master.key \
	  -t arclight .

# Restart dev containers (stop and start)
restart:
	docker compose down
	docker compose -f docker-compose-prod.yml up -d
