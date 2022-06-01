# Envoy and Oathkeeper

This example shows an example of using Oathkeeper with Envoy.

## Overview

Request flow:

1. Request lands on Envoy
1. Envoy uses ext_authz to forward authentication to http://oathkeeper/decision API
1. `cookie_sesion` authentication checks authentication and returns request back to Envoy
1. Hydrator adds an additional header to the request
1. Envoy proxies request to `hello` service

## Develop

Ory Oathkeeper Access Rules: [`access-rules.yml`](./oathkeeper/access-rules.yml) Ory Oathkeeper Configuration:
[`oathkeeper.yml`](./oathkeeper/oathkeeper.yml)

### Prerequisites

1. [Docker](https://docs.docker.com/get-docker/)
1. [Envoy](https://www.envoyproxy.io/docs/envoy/latest/start/install)
1. [Ory Oathkeeper](https://www.ory.sh/docs/oathkeeper/install)

### Run locally

```bash
git clone git@github.com:ory/examples
cd examples/oathkeeper/08-envoy-header
docker-compose up
```

Wait for a couple of seconds and open `http://127.0.0.1:8080/hello`

## Contribute

Feel free to [open a discussion](https://github.com/ory/examples/discussions/new) to provide feedback or talk about ideas, or
[open an issue](https://github.com/ory/examples/issues/new) if you want to add your example to the repository or encounter a bug.
You can contribute to Ory in many ways, see the [Ory Contributing Guidelines](https://www.ory.sh/docs/ecosystem/contributing) for
more information.
