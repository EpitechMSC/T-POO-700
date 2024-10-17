#!/bin/bash

# Variables
BACKEND_CONTAINER="thjeveknc/phoenix-backend"  # e.g., webapp1
FRONTEND_CONTAINER="thjeveknc/vue-frontend"  # e.g., webapp2
NETWORK_NAME="app_network"  # e.g., myapp_network
LATEST_IMAGE="$IMAGE_NAME:latest"

# Create Docker network if it doesn't exist
if ! docker network ls | grep -q $NETWORK_NAME; then
    echo "Creating network $NETWORK_NAME..."
    docker network create $NETWORK_NAME
else
    echo "Network $NETWORK_NAME already exists."
fi

# Pull the latest image
docker pull "$FRONTEND_CONTAINER:latest"
docker pull "$BACKEND_CONTAINER:latest"

# Get the currently running image ID of the containers
# CURRENT_BACKEND_ID=$(docker inspect --format="{{.Image}}" $BACKEND_CONTAINER 2>/dev/null)
# CURRENT_FRONTEND_ID=$(docker inspect --format="{{.Image}}" $FRONTEND_CONTAINER 2>/dev/null)

# # Get the latest pulled image ID
# LATEST_BACKEND_ID=$(docker images --no-trunc --quiet "$BACKEND_CONTAINER:latest")
# LATEST_FRONTEND_ID=$(docker images --no-trunc --quiet "$FRONTEND_CONTAINER:latest")

# # Check if the latest image is already running for both containers
# if [ "$CURRENT_BACKEND_ID" = "$LATEST_BACKEND_ID" ] && [ "$CURRENT_FRONTEND_ID" == "$LATEST_FRONTEND_ID" ]; then
#     echo "The latest version of containers is already running in both containers. No need to redeploy."
#     exit 0
# else
#     echo "A new version of $IMAGE_NAME is available. Redeploying..."
# fi

# Stop and remove the old containers
#if [ "$(docker ps -q -f name=backend_gotham)" ]; then
    echo "Stopping the old container $BACKEND_CONTAINER..."
    docker stop "backend_gotham"
    echo "Removing the old container $BACKEND_CONTAINER..."
    docker rm "backend_gotham"
#fi

#if [ "$(docker ps -q -f name=frontend_gotham)" ]; then
    echo "Stopping the old container $FRONTEND_CONTAINER..."
    docker stop "frontend_gotham"
    echo "Removing the old container $FRONTEND_CONTAINER..."
    docker rm "frontend_gotham"
#fi

# Run the new containers
echo "Starting a new container $BACKEND_CONTAINER with the latest image..."
docker run -e SECRET_KEY_BASE=GGZsehjQB9/SeBXcwgiXCjf7ufksUV7XmB8wG/76wj6A8p4BsCziCcpQLVjDogFO \ 
        -e DATABASE_URL=postgres://postgres:postgres@database:5432/time_manager \ 
        -d --name "backend_gotham" --network $NETWORK_NAME "$BACKEND_CONTAINER:latest"

echo "Starting a new container $FRONTEND_CONTAINER with the latest image..."
docker run -p 8080:8080 -d --name "frontend_gotham" --network $NETWORK_NAME "$FRONTEND_CONTAINER:latest"

echo "Deployment completed successfully."