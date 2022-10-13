format:
	echo "TODO: add Python formatter"

install: node_modules  poetry.lock
	poetry install

.PHONY: test
test: install .bin/ory
	./test.sh

.bin/ory: Makefile
	curl https://raw.githubusercontent.com/ory/meta/master/install.sh | sh -s -- -d -b .bin ory v0.1.44

node_modules: package-lock.json
	npm ci
	touch node_modules
