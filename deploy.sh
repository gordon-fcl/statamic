#!/bin/bash
set -e

echo "Starting deployment..."

# Stop containers
echo "Stopping containers..."
podman-compose down

# Rebuild and start containers
echo "Building and starting containers..."
podman-compose up -d --build

# Wait for containers to be ready
echo "Waiting for containers to start..."
sleep 5

# Install dependencies
echo "Installing composer dependencies..."
podman exec -u root statamic_app composer install --no-dev --optimize-autoloader

# Fix permissions
echo "Fixing permissions..."
podman exec -u root statamic_app chown -R 1000:1000 /var/www/html

# Clear caches
echo "Clearing Statamic caches..."
podman exec statamic_app php please stache:clear
podman exec statamic_app php please cache:clear

echo "Deployment complete!"
