#!/bin/bash

# Download and extract WordPress
wget https://wordpress.org/latest.tar.gz -O /tmp/latest.tar.gz \
    && tar -xzf /tmp/latest.tar.gz --strip-components=1 -C /var/www/html \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Start Apache
apache2-foreground

