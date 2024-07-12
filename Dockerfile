# Use official PHP image as a base
FROM php:7.4-apache

# Install required packages
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    imagemagick \
    libmagickwand-dev \
    unzip \
    wget \
    && docker-php-ext-install -j$(nproc) pdo pdo_mysql xml gd \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# Enable Apache modules
RUN a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html

# Download Omeka S
RUN wget https://github.com/omeka/omeka-s/releases/download/v4.1.1/omeka-s-4.1.1.zip -O omeka-s.zip \
    && unzip omeka-s.zip \
    && mv omeka-s/* . \
    && rm -rf omeka-s omeka-s.zip \
    && ls -la

# Copy custom database.ini file
COPY config/database.ini config/database.ini

# Set permissions
RUN chown -R www-data:www-data /var/www/html/files \
    && chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]