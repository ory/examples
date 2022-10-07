format: .bin/ory node_modules  # formats the source code
	.bin/ory dev headers license
	npm exec -- prettier --write .
	(cd django-ory-cloud && make --no-print-dir format)

.bin/ory: Makefile
	curl https://raw.githubusercontent.com/ory/meta/master/install.sh | bash -s -- -b .bin ory v0.1.43
	touch .bin/ory

node_modules: package-lock.json
	npm ci
	touch node_modules
