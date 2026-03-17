#!/usr/bin/env bash
set -euo pipefail

# Zero-downtime deploy via SSH + Docker compose swap
REMOTE_USER="${DEPLOY_USER:-deploy}"
REMOTE_HOST="${DEPLOY_HOST:?DEPLOY_HOST required}"
REMOTE_DIR="${DEPLOY_DIR:-/opt/app}"
IMAGE="${DOCKER_IMAGE:?DOCKER_IMAGE required}"
TAG="${GITHUB_SHA:-latest}"

echo "Deploying $IMAGE:$TAG to $REMOTE_HOST..."

ssh "$REMOTE_USER@$REMOTE_HOST" bash -s << EOF
  set -euo pipefail
  cd $REMOTE_DIR

  # Pull new image
  docker pull $IMAGE:$TAG

  # Update tag in compose
  sed -i "s|$IMAGE:.*|$IMAGE:$TAG|" docker-compose.yml

  # Rolling restart
  docker-compose up -d --no-deps --build app
  docker-compose run --rm app node migrations/run.js

  # Clean old images
  docker image prune -f
EOF

echo "Deploy complete."
