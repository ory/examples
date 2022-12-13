IMAGE_NAME=dotnet-ory-network-example

format:
	echo "TODO: add C# formatter"

docker-build:
	docker build src -t $(IMAGE_NAME)

docker-run: docker-build
	docker run -d --rm -p 5286:5286 -p 4000:4000 --name="$(IMAGE_NAME)" $(IMAGE_NAME)

docker-stop:
	docker stop "$(IMAGE_NAME)"

.PHONY: test
test: node_modules
	./test.sh

node_modules: package-lock.json
	npm ci
	npx playwright install
	touch node_modules
