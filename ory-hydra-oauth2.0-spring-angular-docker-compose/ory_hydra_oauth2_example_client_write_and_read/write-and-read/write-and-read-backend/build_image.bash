#!/bin/bash

# export HTTP_PROXY="http://proxyuser:proxypass@192.168.20.4:8822/"
# export HTTPS_PROXY="http://proxyuser:proxypass@192.168.20.4:8822/"
# export NO_PROXY="localhost,127.0.0.1"

export REPO_IMAGE="chistousov"
export PROJECT_NAME="ory-hydra-oauth2-example-client-write-and-read-backend"
export VERSION="1.0.0"

docker pull paketobuildpacks/builder-jammy-full:0.3.316

./gradlew clean test
./gradlew bootBuildImage --builder=paketobuildpacks/builder-jammy-full:0.3.316

# publish in docker hub 
# docker login
# docker push $REPO_IMAGE/$PROJECT_NAME:$VERSION
# docker logout
# docker rmi $REPO_IMAGE/$PROJECT_NAME:$VERSION
