#!/bin/bash
WORDPRESS_URL=https://wordpress-example.apps.ocp4.example.com

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
