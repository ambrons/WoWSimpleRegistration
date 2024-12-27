FROM php:8-alpine3.21
RUN apk update && apk add build-base
RUN apk add  libpng-dev \
	&&  apk add freetype-dev \
	&&  apk add libmcrypt-dev \
	&&  apk add libpng-dev \
	&&  apk add libjpeg-turbo \
	&&  apk add libjpeg-turbo-dev \
	&&  apk add oniguruma-dev
RUN docker-php-ext-install mysqli pdo pdo_mysql \
  	&& docker-php-ext-configure gd \
    	&& docker-php-ext-install gd \
    	&& docker-php-ext-install mbstring \
    	&& docker-php-ext-enable gd
RUN apk add libzip-dev zlib-dev git zip \
  	&& docker-php-ext-install zip
RUN apk add --update --no-cache gmp gmp-dev \
    	&& docker-php-ext-install gmp
RUN curl -sS https://getcomposer.org/installer | php \
 && mv composer.phar /usr/local/bin/ \
&& ln -s /usr/local/bin/composer.phar /usr/local/bin/composer
COPY --chown=www-data:www-data . /home/www-data
WORKDIR /home/www-data/application
RUN composer update && composer install --prefer-source --no-interaction
RUN mv /home/www-data/application/config/config.php.docker /home/www-data/application/config/config.php
WORKDIR /home/www-data/
ENV PATH="~/.composer/vendor/bin:./vendor/bin:${PATH}"
EXPOSE 8000
ENTRYPOINT php -S 0.0.0.0:8000
