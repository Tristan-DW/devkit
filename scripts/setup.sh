#!/usr/bin/env bash
set -euo pipefail

echo "Setting up dev environment..."

# Check dependencies
command -v node >/dev/null 2>&1 || { echo "node required but not found"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "docker required but not found"; exit 1; }

# Install npm deps
if [ -f package.json ]; then
  echo "Installing npm dependencies..."
  npm install
fi

# Copy env file
if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
  echo "Created .env from .env.example - update values before running"
fi

# Start services
echo "Starting Docker services..."
docker-compose -f docker/compose.dev.yml up -d

echo "Setup complete. Run: npm run dev"
