format: node_modules
	npm exec -- prettier --write .
	(cd django-ory-cloud && make --no-print-dir format)

node_modules: package-lock.json
	npm ci
	touch node_modules
