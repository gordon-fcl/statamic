#!/bin/bash

# Exit on any error
set -e

echo "--- 1. Breaking Namespace Deadlocks ---"
# This is the 'Master Key'. It lets you act as the container root 
# to give the files back to your host user (1000).
podman unshare chown -R 1000:1000 ./site

echo "--- 2. Building Statamic Image ---"
podman build --pull -t statamic-local .

echo "--- 3. Deploying Containers ---"
# Start PHP-FPM
podman run -d \
  --name statamic_app \
  --replace \
  --restart always \
  --network web-stack \
  --userns=keep-id \
  -v ./site:/var/www/html:z \
  statamic-local

# Start Nginx
podman run -d \
  --name statamic_web \
  --replace \
  --restart always \
  --network web-stack \
  --userns=keep-id \
  -v ./site:/var/www/html:ro,z \
  -v ./nginx.conf:/etc/nginx/conf.d/default.conf:ro,z \
  nginx:alpine

echo "--- 4. Running Application Tasks ---"
# Install PHP dependencies
podman exec statamic_app composer install --no-interaction --optimize-autoloader

# Compile Frontend Assets (Vite/Tailwind)
podman exec statamic_app npm install
podman exec statamic_app npm run build

# Clear and Cache Laravel configurations
podman exec statamic_app php artisan config:cache
podman exec statamic_app php artisan route:cache

echo "--- Deployment Complete ---"
