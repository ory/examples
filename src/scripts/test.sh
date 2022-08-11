#!/bin/bash

set -euxo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../.."

export ORY_SDK_URL=https://playground.projects.oryapis.com
export ORY_UI_URL=https://playground.projects.oryapis.com/ui

#
# Please add any build steps to the Makefile and not here!
#

cd django-ory-cloud && \
  cd mysite && \
  poetry run python manage.py migrate && \
poetry run python manage.py runserver &
ory proxy --no-jwt --port 4000 http://localhost:8000/ &

trap "exit" INT TERM ERR
trap 'kill $(jobs -p)' EXIT

npx wait-on -v -t 300000 tcp:localhost:4000

npm run test:e2e
