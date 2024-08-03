# Base Image
FROM php:8.0-apache

# Add this at the top of your Dockerfile to break cache
ARG NO_CACHE
RUN echo "Cache busting: $NO_CACHE"

# Install required packages
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    wget \
    libpng-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libsodium-dev \
    libjpeg-dev \
    libfreetype6 \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-ext-install exif \
    && docker-php-ext-install sodium \
    && docker-php-ext-install soap \
    && pecl install redis \
    && docker-php-ext-enable redis

# Install SourceGuardian
COPY loaders.linux-x86_64.tar.gz /tmp/
RUN tar -xzf /tmp/loaders.linux-x86_64.tar.gz -C /tmp \
    && mv /tmp/ixed.8.0.lin /usr/local/lib/php/extensions/ixed.8.0.lin \
    && echo "extension=ixed.8.0.lin" > /usr/local/etc/php/conf.d/sourceguardian.ini

# Install ionCube Loader
COPY ioncube_loaders_lin_x86-64.tar.gz /tmp/
RUN tar -xzf /tmp/ioncube_loaders_lin_x86-64.tar.gz -C /tmp \
    && mv /tmp/ioncube/ioncube_loader_lin_8.1.so /usr/local/lib/php/extensions/ \
    && echo "zend_extension=ioncube_loader_lin_8.1.so" > /usr/local/etc/php/conf.d/00-ioncube.ini

# Configure PHP
COPY php.ini /usr/local/etc/php/php.ini

# Set up WordPress directory
RUN mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Set up Apache Virtual Host
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Enable Apache modules
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80
