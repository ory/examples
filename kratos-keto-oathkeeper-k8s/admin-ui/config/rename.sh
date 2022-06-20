#!/bin/bash
grep -rl http://localhost:4434 /usr/share/nginx/html | xargs sed -i s@http://localhost:4434/@$KRATOS_PRIVATE_API@g
grep -rl /static/ /usr/share/nginx/html | xargs sed -i s@/static/@/admin/static/@g
grep -rl /favicon.ico /usr/share/nginx/html | xargs sed -i s@/favicon.ico@/admin/favicon.ico@g
