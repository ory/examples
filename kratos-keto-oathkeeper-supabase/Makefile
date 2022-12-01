.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

test:
	go test ./...

apitest:
	@curl -s -o response.txt -w "%{http_code}" http://localhost:8090/api/url

create_migration:
	migrate create -ext sql -dir db/migrations -seq create_url_table

lint:
	golangci-lint run ./...
