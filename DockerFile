FROM php:8.4-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    libpng-dev libjpeg-turbo-dev freetype-dev libzip-dev \
    icu-dev oniguruma-dev zlib-dev nodejs npm git unzip

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip intl bcmath mysqli pdo_mysql exif

# Install Composer from the official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Ensure the container runs as the standard web user
USER www-data
