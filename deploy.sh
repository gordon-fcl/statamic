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
podman exec statamic_app composer install --no-dev --optimize-autoloader

# Clear caches
echo "Clearing Statamic caches..."
podman exec statamic_app php please stache:clear
podman exec statamic_app php please cache:clear

echo "Deployment complete!"
