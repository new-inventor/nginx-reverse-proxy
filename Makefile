SHELL = /bin/sh
-include ./.env
export

DATA_PATH := $(realpath .)/data
TEMPLATES_PATH := $(realpath ./tpl)

init: create-dirs process-templates get-dh-params
	docker compose -f ./docker-compose.init.yaml -p init --env-file ./.env up
	#docker compose run --rm  certbot certonly --webroot --webroot-path /var/www/certbot/ -d $(HOST)
	#docker compose -f ./docker-compose.init.yaml -p init down

create-dirs:
	mkdir -p "$(DATA_PATH)/certbot/conf/live"
	mkdir -p "$(DATA_PATH)/certbot/conf/renewal-hooks/deploy"
	mkdir -p "$(DATA_PATH)/certbot/conf/renewal-hooks/post"
	mkdir -p "$(DATA_PATH)/certbot/conf/renewal-hooks/pre"
	mkdir -p "$(DATA_PATH)/certbot/logs"
	mkdir -p "$(DATA_PATH)/certbot/www"
	mkdir -p "$(DATA_PATH)/nginx/conf"
	mkdir -p "$(DATA_PATH)/nginx-init"

process-templates:
	cp -f $(TEMPLATES_PATH)/nginx/conf/host.locations $(DATA_PATH)/nginx/conf/host.locations
	cp -f $(TEMPLATES_PATH)/nginx/conf/conf.nginx $(DATA_PATH)/nginx/conf/default.conf
	sed -i "s/HOST/$(subst /,\/,$(HOST))/g" $(DATA_PATH)/nginx/conf/default.conf
	cp -r $(TEMPLATES_PATH)/nginx-init/conf.nginx $(DATA_PATH)/nginx-init/default.conf
	sed -i "s/HOST/$(subst /,\/,$(HOST))/g" $(DATA_PATH)/nginx-init/default.conf

get-dh-params:
	mkdir -p "$(DATA_PATH)/nginx/dh"
	curl $(DH_PARAM_PATH) > $(DATA_PATH)/nginx/dh/dhparam

start:
	docker compose -p reverse-proxy up -d

renew:
	docker compose run --rm certbot renew

stop:
	docker compose -p reverse-proxy down
