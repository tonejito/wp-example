#!/bin/bash
WORDPRESS_WWW_HOST=wordpress-example.apps.ocp4.example.com

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
