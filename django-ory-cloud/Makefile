install: node_modules  poetry.lock
	poetry install

.PHONY: test
test: install .bin/ory
	./test.sh

.bin/ory: Makefile
	curl https://raw.githubusercontent.com/ory/meta/master/install.sh | sh -s -- -d -b .bin ory v0.1.36

node_modules: package.json package-lock.json
	npm i
	touch node_modules
