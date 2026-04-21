FROM php:8.2-cli-bookworm

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libonig-dev \
    libpng-dev \
    libsqlite3-dev \
    libwebp-dev \
    libxml2-dev \
    libzip-dev \
    zlib1g-dev; \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-install -j"$(nproc)" gd; \
    docker-php-ext-install -j"$(nproc)" intl; \
    docker-php-ext-install -j"$(nproc)" mbstring; \
    docker-php-ext-install -j"$(nproc)" mysqli pdo_mysql; \
    docker-php-ext-install -j"$(nproc)" pdo_sqlite sqlite3; \
    docker-php-ext-install -j"$(nproc)" zip; \
    docker-php-ext-install -j"$(nproc)" exif; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN mkdir -p data/system data/temp/files data/temp/log data/temp/thumb \
 && chmod -R 0777 data config

ENV PORT=8080

EXPOSE 8080

CMD ["sh", "-c", "mkdir -p data/system data/temp/files data/temp/log data/temp/thumb && chmod -R 0777 data config || true && php -d variables_order=EGPCS -S 0.0.0.0:${PORT:-8080} railway-router.php"]
