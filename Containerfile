FROM wordpress:5.7-php7.4-apache AS wordpress

# persistent dependencies
RUN set -eux; \
	pwd ; \
	apt-get -qq update; \
	apt-get -qq install -y --no-install-recommends \
		gnupg \
		unzip \
	; \
	rm -rf /var/lib/apt/lists/*

# Install wpcli
# https://github.com/docker-library/wordpress/blob/master/cli/php7.4/alpine/Dockerfile
ENV WORDPRESS_CLI_VERSION 2.4.0
RUN set -ex; \
	curl -fso /usr/local/bin/wp -fL "https://github.com/wp-cli/wp-cli/releases/download/v${WORDPRESS_CLI_VERSION}/wp-cli-${WORDPRESS_CLI_VERSION}.phar"; \
	chmod -c +x /usr/local/bin/wp; \
	which wp ; \
	wp --allow-root --version

# Install theme files
WORKDIR /usr/src/wordpress
RUN rm -v /var/www/html/* || true ; \
	test -d wp-content/themes || mkdir -vp wp-content/themes ; \
	\
	curl -fsO https://downloads.wordpress.org/theme/twentyseventeen.2.7.zip ; \
	unzip -q twentyseventeen.2.7.zip ; \
	mv twentyseventeen wp-content/themes ; \
	rm twentyseventeen.2.7.zip ; \
	\
	chown -R www-data:www-data /var/www/html /usr/src/wordpress


WORKDIR /var/www/html
VOLUME /var/www/html

COPY --chown=www-data:www-data wp-config-docker.php /usr/src/wordpress/
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
