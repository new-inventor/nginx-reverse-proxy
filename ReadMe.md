## Nginx + Certbot reverse proxy
This repo introduces to you commands set for simple start containerized version of nginx + certbot revers proxy.
Init command creates directories, configs for nginx and other needed files.

**Cert bot now can renew your cert in automatic mode and nginx can use new certificates automatically too.**

## Set up process
1. get domain name
2. set A record to your server IP
3. git clone project to your server
4. run `cp .env.example .env`
5. change env parameters(see: ENV parameters section)
6. run `make init`
7. quite from interactive docker mode(press Ctrl + C) after certbot finish certification process
8. change `./data/nginx/conf/host.locations` to your needs, for set up the nginx routing.
9. run `make start f='path/to/service/docker-compose.yaml'`

## ENV parameters
HOST - Your domain

EMAIL - email for receiving renewal notifications

DH_PARAM_PATH - default to https://ssl-config.mozilla.org/ffdhe2048.txt mozilla recommended dh param file

CA_PATH_PATH=https://letsencrypt.org/certs/isrgrootx1.pem - CA certificate of lets encrypt provider

## Make commands
You can see this help with run `make`

- `init`                init reverse proxy with all actions needed;
- `create-dirs`         create needed directories; 
- `process-templates`   copy templates with env variable insertion; 
- `get-dh-params`       copy dhparams file from mozilla 
- `get-ca`              copy ca file from let's encrypt 
- `start`               start reverse proxy 
- `renew`               renew certs 
- `stop`                stop reverse proxy 
- `update-nginx-conf`   update nginx config without nginx restart
