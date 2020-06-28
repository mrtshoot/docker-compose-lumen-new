FROM localhub.etod.me/php:7.2-fpm

# Copy composer.lock and composer.json
COPY ./lumen-app/yourprojectname/composer.lock ./lumen-app/yourprojectname/composer.json /var/www/

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    supervisor

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
COPY ./lumen-app/yourprojectname /var/www

# Copy existing application directory permissions
COPY --chown=www:www ./lumen-app/yourprojectname /var/www

#Add SSH Server and Requirements
RUN apt update && apt install openssh-server -y

#Create SSH and Composer Directories
RUN mkdir /home/www/.ssh /home/www/.composer
RUN chown -R www:www /home/www/

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
