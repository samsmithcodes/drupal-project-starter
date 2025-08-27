FROM php:8.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    wget \
    rsync \
    chromium \
    libonig-dev \
    libpng-dev \
    libjpeg-dev \
    libwebp-dev \
    libavif-dev \
    zlib1g-dev \
    libzip-dev \
    libnss3-dev \
    libicu-dev \
    libssl-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg --with-webp --with-avif
RUN docker-php-ext-install pdo_mysql mbstring bcmath gd zip exif intl

# Set php memory limit
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
RUN sed -i 's/expose_php = On/expose_php = Off/g' /usr/local/etc/php/php.ini

# Define a directory for composer to use for cache
RUN mkdir -p /var/www/.cache
RUN chown www-data:www-data /var/www/.cache

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

USER www-data

EXPOSE 9000
