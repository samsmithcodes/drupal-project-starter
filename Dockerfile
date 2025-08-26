FROM php:8.4-cli-alpine

# Install Alpine dependencies
RUN apk add --no-cache \
    curl \
    npm \
    unzip \
    bash \
    git

# Install GD build deps + runtime libs
RUN set -eux; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
        freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev \
    && apk add --no-cache \
        freetype libjpeg-turbo libpng libwebp \
    && docker-php-ext-configure gd \
        --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j"$(nproc)" gd \
    && apk del .build-deps

# Set up folders
RUN mkdir -p /files /app
COPY DevOps /files/DevOps

# Install Composer globally
RUN curl -s https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Entry script
RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo "composer create-project drupal/cms" >> /entrypoint.sh && \
    echo "cp -r /files/DevOps /app/" >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

WORKDIR /app
CMD ["/entrypoint.sh"]
