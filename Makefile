#!/usr/bin/make -f
SHELL=/bin/bash
WORDPRESS_WWW_HOST?=wordpress-example.apps.ocp4.example.com
WP_CONTAINER?=wp-example_wp_1
DB_CONTAINER?=wp-example_db_1
CLI_CONTAINER?=wp-example_cli_1

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
	  --title="Example WordPress" \
	  --admin_user=admin \
	  --admin_password=redhat \
	  --admin_email=wordpress@localhost.local \
	  --skip-email
	wp maintenance-mode activate
	wp theme install twentyseventeen --activate
	wp option update home "http://${WORDPRESS_WWW_HOST}"
	wp option update siteurl "http://${WORDPRESS_WWW_HOST}"
	wp maintenance-mode deactivate
	wp maintenance-mode status
	wp core is-installed
