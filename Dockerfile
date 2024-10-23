FROM php:8.3.12-apache

# Install MySQL server and necessary PHP extensions, including WebP support for GD
RUN apt-get update && \
    apt-get install -y default-mysql-server libpng-dev libjpeg-dev libfreetype6-dev libwebp-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install gd mysqli pdo pdo_mysql && \
    apt-get clean

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Expose port 80 for the web server
EXPOSE 80

# Copy Apache config file to the container
COPY ./my-apache-config.conf /etc/apache2/sites-available/000-default.conf

# Copy php.ini in respective file -- Optional
COPY ./php.ini /usr/local/etc/php/php.ini

# Copy entrypoint script
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Use mysqld directly to initialize and run MySQL
RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld && \
    mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

# Set entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["apache2-foreground"]
