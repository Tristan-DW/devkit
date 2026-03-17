# PHP-FPM + Laravel production image
FROM php:8.2-fpm-alpine AS base

RUN apk add --no-cache nginx supervisor

RUN docker-php-ext-install pdo pdo_mysql opcache && \
    pecl install redis && docker-php-ext-enable redis

FROM base AS deps
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --optimize-autoloader

FROM base AS runner
WORKDIR /app
COPY --from=deps /app/vendor ./vendor
COPY . .
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache && \
    chown -R www-data:www-data storage bootstrap/cache

COPY docker/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/supervisord.conf /etc/supervisord.conf

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
