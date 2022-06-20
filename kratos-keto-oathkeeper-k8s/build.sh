#!/bin/bash
set -u

# Check for local version of kustomize
KUSTOMIZE_CLIENT="kustomize"
if [ -e "./kustomize" ]; then
  KUSTOMIZE_CLIENT="./kustomize"
fi

KUSTOMIZE="$KUSTOMIZE_CLIENT build"
ROOT_PATH=$(dirname $0)

for service in $ROOT_PATH/*/; do
# if new version exists, use it instead of old
  if [ -f "$(basename $service)/kustomization.yaml" ]; then
      echo "---" # yaml separator in stdout
      echo "# NEW VERSION ./kustomization.yaml"
      ${KUSTOMIZE} "$(basename $service)"
      if [ $? -ne 0 ]; then
          echo "[ERROR] $service"
          exit
      fi
      echo "" #newline
  fi
done