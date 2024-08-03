# Base Image
FROM php:8.1-apache

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
    libbz2-dev \
    libgmp-dev \
    libwebp-dev \
    libxpm-dev \
    libavif-dev \
    libreadline-dev \
    libtidy-dev \
    libxslt-dev \
    libssl-dev \
    libmemcached-dev \
    libmcrypt-dev \
    graphicsmagick \
    graphicsmagick-libmagick-dev-compat

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    mysqli \
    zip \
    exif \
    sodium \
    soap \
    bcmath \
    calendar \
    dba \
    dom \
    fileinfo \
    gettext \
    gmp \
    iconv \
    intl \
    mbstring \
    pcntl \
    pdo \
    phar \
    posix \
    shmop \
    sockets \
    sysvmsg \
    sysvsem \
    sysvshm \
    tidy \
    xsl

# Install PECL extensions separately to isolate errors
RUN pecl install redis \
    && docker-php-ext-enable redis

RUN pecl install memcache \
    && docker-php-ext-enable memcache

RUN pecl install memcached \
    && docker-php-ext-enable memcached

RUN pecl install igbinary \
    && docker-php-ext-enable igbinary

RUN pecl install msgpack \
    && docker-php-ext-enable msgpack

RUN pecl install mcrypt-1.0.6 \
    && docker-php-ext-enable mcrypt

RUN pecl install channel://pecl.php.net/gmagick-2.0.6RC1 \
    && docker-php-ext-enable gmagick

# Install SourceGuardian
COPY loaders.linux-x86_64.tar.gz /tmp/
RUN tar -xzf /tmp/loaders.linux-x86_64.tar.gz -C /tmp \
    && mv /tmp/ixed.8.1.lin /usr/local/lib/php/extensions/ixed.8.1.lin \
    && echo "extension=ixed.8.1.lin" > /usr/local/etc/php/conf.d/sourceguardian.ini

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
