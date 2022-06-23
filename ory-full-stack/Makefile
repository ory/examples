.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: ## Runs everything (Flask apps, Kratos, Keto, Hydra and Oathkeeper)
	docker-compose -f docker-compose.yml -f keto.yml -f kratos.yml -f hydra.yml up --build

with_kratos: ## Runs flask apps with Kratos
	docker-compose -f docker-compose.yml -f kratos.yml up

with_keto: ## Runs flask apps with Keto
	docker-compose -f docker-compose.yml -f keto.yml up

down: ## Shut downs everything
	docker-compose -f docker-compose.yml -f keto.yml -f kratos.yml down --remove-orphans
