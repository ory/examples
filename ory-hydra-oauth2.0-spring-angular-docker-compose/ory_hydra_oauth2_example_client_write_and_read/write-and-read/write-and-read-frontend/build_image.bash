#!/bin/bash

# export HTTP_PROXY="http://proxyuser:proxypass@192.168.20.4:8822/"
# export HTTPS_PROXY="http://proxyuser:proxypass@192.168.20.4:8822/"
# export NO_PROXY="localhost,127.0.0.1"

export REPO_IMAGE="chistousov"
export PROJECT_NAME="ory-hydra-oauth2-example-client-write-and-read-frontend"
export VERSION="1.0.0"

# install pack
# https://buildpacks.io/docs/tools/pack/#linux-script-install
# (curl -sSL "https://github.com/buildpacks/pack/releases/download/v0.29.0/pack-v0.29.0-linux.tgz" | sudo tar -C /usr/local/bin/ --no-same-owner -xzv pack)

npm i

ng test --no-watch --code-coverage --browsers Firefox
rm -rf dist/ || true
npm run build

docker pull paketobuildpacks/builder-jammy-full:0.3.316

rm -rf app_server/ || true
mkdir app_server
mv dist/ app_server/dist

pack -v \
--path app_server \
build \
$REPO_IMAGE/$PROJECT_NAME:$VERSION \
--env HTTP_PROXY="$HTTP_PROXY" \
--env HTTPS_PROXY="$HTTPS_PROXY" \
--env NO_PROXY="$NO_PROXY" \
--env BP_NODE_OPTIMIZE_MEMORY=true \
--env BP_HEALTH_CHECKER_ENABLED=true \
--env BP_LAUNCHPOINT="dist/write-and-read-frontend/server/server.mjs" \
--buildpack gcr.io/paketo-buildpacks/nodejs \
--buildpack gcr.io/paketo-buildpacks/health-checker:latest \
--builder paketobuildpacks/builder-jammy-full:0.3.316

rm -rf app_server

# publish in docker hub
# docker login
# docker push $REPO_IMAGE/$PROJECT_NAME:$VERSION
# docker logout
# docker rmi $REPO_IMAGE/$PROJECT_NAME:$VERSION
