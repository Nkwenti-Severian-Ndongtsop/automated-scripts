#!/bin/bash

echo "🔧 Welcome to GHCR Docker Push Script"
echo "--------------------------------------"

# Prompt for details
read -p "👤 GitHub Username: " USERNAME
read -p "📦 Image Name (e.g. my-app): " IMAGE_NAME
read -p "🗂️  GitHub Repo Name (optional, for tagging info): " REPO
read -p "🏷️  Image Version [default: latest]: " VERSION
VERSION=${VERSION:-latest}

read -p "📁 Dockerfile directory (default: current '.'): " DOCKER_DIR
DOCKER_DIR=${DOCKER_DIR:-.}

GHCR_HOST="ghcr.io"
IMAGE_TAG="$GHCR_HOST/$USERNAME/$IMAGE_NAME:$VERSION"

# Build the Docker image
echo "🛠️  Building Docker image as $IMAGE_TAG..."
docker build -t "$IMAGE_TAG" "$DOCKER_DIR"

# Login to GHCR
echo "🔐 Login to GitHub Container Registry"
read -s -p "🔑 Enter your GitHub Personal Access Token: " GHCR_TOKEN
echo
echo "$GHCR_TOKEN" | docker login "$GHCR_HOST" -u "$USERNAME" --password-stdin

# Push the Docker image
echo "📤 Pushing $IMAGE_TAG to GHCR..."
docker push "$IMAGE_TAG"

# Done
echo "✅ Done! Image pushed to: https://$GHCR_HOST/$USERNAME/$IMAGE_NAME"
