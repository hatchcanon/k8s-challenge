# Use the official PHP 8.0 image as the base
FROM php:7.4-apache

ENV DB_HOST mysql-service
ENV DB_USER dbuser
ENV DB_PASSWORD dbpassword
ENV DB_NAME ecommerce

# Add Configuration file
RUN echo "PassEnv *" >> /etc/apache2/apache2.conf

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
RUN chown -R www-data:www-data /var/www/html

RUN sed -i 's/index.html/index.php/g' /etc/apache2/apache2.conf
EXPOSE 80
