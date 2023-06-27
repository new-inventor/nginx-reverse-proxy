SHELL = /bin/sh
-include ./.env
export

DATA_PATH := $(realpath .)/data
TEMPLATES_PATH := $(realpath ./tpl)

#--init: init reverse proxy with all actions needed;
init: create-dirs process-templates get-dh-params get-ca
	docker compose -f ./docker-compose.init.yaml -p init --env-file ./.env up

#--create-dirs: create needed directories;
create-dirs:
	mkdir -p "$(DATA_PATH)/certbot/conf/live"
	mkdir -p "$(DATA_PATH)/certbot/conf/renewal-hooks/deploy"
	mkdir -p "$(DATA_PATH)/certbot/conf/renewal-hooks/post"
	mkdir -p "$(DATA_PATH)/certbot/conf/renewal-hooks/pre"
	mkdir -p "$(DATA_PATH)/certbot/logs"
	mkdir -p "$(DATA_PATH)/certbot/www"
	mkdir -p "$(DATA_PATH)/nginx/conf"
	mkdir -p "$(DATA_PATH)/nginx-init"

#--process-templates: copy templates with env variable insertion;
process-templates:
	cp --backup=numbered -f $(TEMPLATES_PATH)/nginx/conf/host.locations $(DATA_PATH)/nginx/conf/host.locations
	cp --backup=numbered -f $(TEMPLATES_PATH)/nginx/conf/conf.nginx $(DATA_PATH)/nginx/conf/default.conf
	sed -i "s/HOST/$(subst /,\/,$(HOST))/g" $(DATA_PATH)/nginx/conf/default.conf
	cp --backup=numbered -f $(TEMPLATES_PATH)/nginx-init/conf.nginx $(DATA_PATH)/nginx-init/default.conf
	sed -i "s/HOST/$(subst /,\/,$(HOST))/g" $(DATA_PATH)/nginx-init/default.conf

#--get-dh-params: copy dhparams file from mozilla
get-dh-params:
	mkdir -p "$(DATA_PATH)/nginx/dh"
	curl $(DH_PARAM_PATH) > $(DATA_PATH)/nginx/dh/dhparam

#--get-ca: copy ca file from let's encrypt
get-ca:
	curl $(CA_PATH_PATH) > $(DATA_PATH)/nginx/dh/ca.pem

#--start: start reverse proxy
start:
	docker compose -p reverse-proxy up -d

#--renew: renew certs
renew:
	docker compose -p reverse-proxy run --rm certbot renew

#--stop: stop reverse proxy
stop:
	docker compose -p reverse-proxy down

#--update-nginx-conf: update nginx config without nginx restart
update-nginx-conf:
	docker compose -p reverse-proxy exec nginx nginx -s reload

.DEFAULT_GOAL := help
help:
	@grep -E '^#--.*$$' $(MAKEFILE_LIST) \
	| sed -n 's/.*#--\(.*\)/\1/p' \
	| column -t  -s ':'
