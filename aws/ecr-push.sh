#!/usr/bin/env bash
set -euo pipefail

# Build, tag, and push Docker image to AWS ECR
AWS_REGION="${AWS_REGION:-af-south-1}"
ECR_REGISTRY="${ECR_REGISTRY:?Set ECR_REGISTRY}"
IMAGE_NAME="${IMAGE_NAME:?Set IMAGE_NAME}"
TAG="${GITHUB_SHA:-$(git rev-parse --short HEAD)}"

echo "Logging in to ECR..."
aws ecr get-login-password --region "$AWS_REGION" | \
  docker login --username AWS --password-stdin "$ECR_REGISTRY"

echo "Building $IMAGE_NAME:$TAG..."
docker build -t "$ECR_REGISTRY/$IMAGE_NAME:$TAG" .
docker tag "$ECR_REGISTRY/$IMAGE_NAME:$TAG" "$ECR_REGISTRY/$IMAGE_NAME:latest"

echo "Pushing..."
docker push "$ECR_REGISTRY/$IMAGE_NAME:$TAG"
docker push "$ECR_REGISTRY/$IMAGE_NAME:latest"

echo "Pushed $ECR_REGISTRY/$IMAGE_NAME:$TAG"
