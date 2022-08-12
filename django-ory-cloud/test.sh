#!/bin/bash

set -euxo pipefail

export ORY_SDK_URL=https://playground.projects.oryapis.com
export ORY_UI_URL=https://playground.projects.oryapis.com/ui

(
  cd mysite
  poetry run python manage.py migrate
  poetry run python manage.py runserver &
)
.bin/ory proxy --no-jwt --port 4000 http://localhost:8000/ &

trap "exit" INT TERM ERR
trap 'kill $(jobs -p)' EXIT

npx wait-on -v -t 300000 tcp:localhost:4000

npm run test:e2e
