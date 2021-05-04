#!/usr/bin/make -f
SHELL=/bin/bash
WORDPRESS_WWW_HOST?=wordpress-example.apps.ocp4.example.com
WP_CONTAINER?=wp-example_wp_1
DB_CONTAINER?=wp-example_db_1
CLI_CONTAINER?=wp-example_cli_1

DOCKER?=docker
TAG=quay.io/tonejito/wordpress:5.7-php7.4-apache

build:
	${DOCKER} build -t ${TAG} .
	${DOCKER} push ${TAG}

run:
	docker-compose up

cli:
	docker run -it --rm \
          --name=${CLI_CONTAINER} \
	  --user=33 \
	  --env-file .env \
	  --env WORDPRESS_WWW_HOST="${WORDPRESS_WWW_HOST}" \
          --volume $(CURDIR):/opt \
	  --volumes-from ${WP_CONTAINER} \
	  --network container:${WP_CONTAINER} \
	  wordpress:cli sh

deploy:
	wp core install \
	  --url=http://localhost \
	  --title="${WORDPRESS_TITLE}" \
	  --admin_user="${WORDPRESS_USER}" \
	  --admin_password="${WORDPRESS_PASSWORD}" \
	  --admin_email="${WORDPRESS_EMAIL}" \
	  --skip-email
	wp maintenance-mode activate
	wp option update home    "${WORDPRESS_URL}"
	wp option update siteurl "${WORDPRESS_URL}"
	wp theme install twentyseventeen --activate
	wp maintenance-mode deactivate
	wp maintenance-mode status
	wp core is-installed
