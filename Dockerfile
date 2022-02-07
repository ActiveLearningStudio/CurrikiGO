FROM php:7.2-apache

# Add apache and php config for Laravel
COPY ./tsugi.conf /etc/apache2/sites-available/site.conf
RUN ln -s /etc/apache2/sites-available/site.conf /etc/apache2/sites-enabled/
#RUN sed -i 's/Listen 80/Listen 6300/g' /etc/apache2/ports.conf
RUN a2dissite 000-default.conf && a2ensite site.conf && a2enmod rewrite && a2enmod headers

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy composer.lock and composer.json
#COPY composer.lock composer.json /var/www/
# Set working directory
WORKDIR /var/www
# Install dependencies
RUN apt-get update && apt-get install -y git netcat vim && apt-get clean -y
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data
#RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

WORKDIR /var/www/html/tsugi



# Copy the PHP configuration file
COPY ./php.ini /usr/local/etc/php/
COPY . /var/www/html/tsugi
#COPY . /var/www/html/

COPY ./entrypoint.tsugi.sh ./
RUN chmod +x /var/www/html/tsugi/entrypoint.tsugi.sh

ENTRYPOINT ["sh", "/var/www/html/tsugi/entrypoint.tsugi.sh"]
