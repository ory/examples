SHELL=/bin/bash -euo pipefail

export GO111MODULE        := on
export PATH               := .bin:${PATH}

.PHONY: install
install: package-lock.json  django-ory-cloud/poetry.lock 
		npm i
		cd django-ory-cloud && poetry install

# .PHONY: build-examples
# build-examples:
# 		cd code-examples/protect-page-login/nextjs && npm run build
# 		cd code-examples/protect-page-login/flutter_web_redirect && flutter build web --web-renderer html
# 		cd code-examples/protect-page-login/vue && VUE_APP_API_URL=http://localhost:4007 VUE_APP_ORY_URL=http://localhost:3006 npm run build
# 		cd code-examples/protect-page-login/react && npm run build

.PHONY: test
test: install .bin/ory
		./src/scripts/test.sh

.bin/ory: Makefile
		bash <(curl https://raw.githubusercontent.com/ory/meta/master/install.sh) -d -b .bin ory v0.1.33
		touch -a -m .bin/ory
