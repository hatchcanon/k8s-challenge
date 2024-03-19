# Use the official PHP 8.0 image as the base
FROM php:7.4-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    && docker-php-ext-install mysqli && docker-php-ext-enable mysqli && \
    service apache2 restart

# Enable Apache rewrite module
RUN a2enmod rewrite

# Changes uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# Set the document root
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Copy the application files to the container
COPY /app /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Sets permissions for the web user
RUN chown -R www-data:www-data

RUN sed -i 's/index.html/index.php/g' /etc/apache2/apache2.conf
