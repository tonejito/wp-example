#!/usr/bin/make -f
SHELL=/bin/bash
WORDPRESS_WWW_HOST=?wordpress-example.apps.ocp4.example.com

run:
	docker-compose -f stack.yml up

cli:
	docker run -it --rm \
	  --user=33 \
	  --env-file .env \
	  --env WORDPRESS_WWW_HOST="${WORDPRESS_WWW_HOST}" \
          --volume $(CURDIR):/tmp/host \
	  --volumes-from root_wp_1 \
	  --network container:root_wp_1 \
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
