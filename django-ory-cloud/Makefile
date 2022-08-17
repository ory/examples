install: node_modules  poetry.lock
	poetry install

# .PHONY: build-examples
# build-examples:
# 		cd code-examples/protect-page-login/nextjs && npm run build
# 		cd code-examples/protect-page-login/flutter_web_redirect && flutter build web --web-renderer html
# 		cd code-examples/protect-page-login/vue && VUE_APP_API_URL=http://localhost:4007 VUE_APP_ORY_URL=http://localhost:3006 npm run build
# 		cd code-examples/protect-page-login/react && npm run build

.PHONY: test
test: install .bin/ory
	./test.sh

.bin/ory: Makefile
	curl https://raw.githubusercontent.com/ory/meta/master/install.sh | bash -s -- -d -b .bin ory v0.1.33

node_modules: package.json package-lock.json
	npm i
	touch node_modules
