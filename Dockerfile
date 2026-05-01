FROM php:8.2-cli

# System deps
RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libzip-dev zip

# PHP extensions
RUN docker-php-ext-install pdo pdo_pgsql zip

# Composer install
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copy project
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Laravel setup
RUN php artisan config:clear

# Serve app
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=10000
