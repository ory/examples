#!/bin/bash
set -euo pipefail

# Ory Cloud generated personal access token
token="ory_pat_TOKEN"
# Ory Cloud project ID
project_id="bc962712-15fe-412a-9db7-717df2eb9331"
# subject_id is the id of Ory Cloud Identity
subject_id="49333d9d-e12b-40ff-8dd3-50d99d848baf"
# set up your project slug here
project_slug="loving-turing-uo2cv9nlhi.projects"

ory patch project $project_id --add '/services/permission/config/namespaces=[{"id": 0, "name": "services"}]'

relationtuple='
{
  "namespace": "services",
  "object": "hello-world-service",
  "relation": "access",
  "subject_id": "$subject_id"
}'

curl -X PUT \
     --data "$relationtuple" \
     -H "Authorization: Bearer $token"\
     -H "Content-type: application/json"\
     https://$project_slug.projects.oryapis.com/admin/relation-tuples
