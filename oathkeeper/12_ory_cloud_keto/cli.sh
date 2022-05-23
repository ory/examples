#!/bin/bash
set -euo pipefail

ory patch project bc962712-15fe-412a-9db7-717df2eb9331 --add '/services/permission/config/namespaces=[{"id": 0, "name": "services"}]'

relationtuple='
{
  "namespace": "services",
  "object": "hello-world-service",
  "relation": "access",
  "subject_id": "49333d9d-e12b-40ff-8dd3-50d99d848baf"
}'

curl -X PUT \
     --data "$relationtuple" \
     -H "Authorization: Bearer ory_pat_JOVmnYpbta18UI3Ba9B4UJ5TN1dWlPn5"\
     -H "Content-type: application/json"\
     https://loving-turing-uo2cv9nlhi.projects.oryapis.com/admin/relation-tuples
