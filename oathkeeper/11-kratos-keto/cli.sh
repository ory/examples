#!/bin/bash
set -euo pipefail

relationtuple='
{
  "namespace": "services",
  "object": "hello-world-service",
  "relation": "access",
  "subject_id": "7757f42b-edc4-4fae-80c9-ea577745d4c9"
}'

curl --fail --silent -X PUT \
     --data "$relationtuple" \
     http://127.0.0.1:4467/relation-tuples > /dev/null \
  && echo "Successfully created tuple" \
  || echo "Encountered error"
