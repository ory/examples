# Ory Hydra & Ory Kratos Integration Example

A complete guide to integrating Ory Hydra and Ory Kratos to handle
authentication and authorization for your web applications.

## Overview

In this example, we'll show you how to use Ory Hydra and Ory Kratos to handle
authentication and authorization for your web application. Ory Hydra is an
OAuth2 and OpenID Connect server, while Ory Kratos is a cloud-native identity
management system.

With this integration, you'll be able to handle user registration, login, and
authorization for your web application in a secure and scalable way.

## Develop

### Prerequisites

You'll need the following software to run this example:

- [Docker](https://www.docker.com/get-started)

- [Docker Compose](https://docs.docker.com/compose/install/)

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### Environmental Variables

The example uses the following environment variables:

- PUBLIC_PORT: The public port of the Ory Hydra server

- ADMIN_PORT: The admin port of the Ory Hydra server

- URLS_SELF_ISSUER: The URL used by Ory Kratos to issue tokens

To set these environment variables, create a .env file in the root of the
project and add the following:

```
DATABASE_URL=postgres://kratos:kratos@db:5432/kratos?sslmode=disable
PUBLIC_PORT=4444
ADMIN_PORT=4445
URLS_SELF_ISSUER=http://localhost:4445/
```

### Run locally

To run the example locally, clone the repository and run the following commands
in the root of the project:

```shell script
docker-compose up
```

This will start the Ory Hydra, Ory Kratos, Kratos SelfService UI Node servers in
Docker containers.

Next, create an OAuth2 client and store its data in variable

```shell script
code_client=$(docker-compose exec hydra \
    hydra create client \
    --endpoint http://127.0.0.1:4445 \
    --grant-type authorization_code,refresh_token \
    --response-type code,id_token \
    --format json \
    --scope openid --scope offline \
    --redirect-uri http://127.0.0.1:5555/callback)
```

Store OAuth2 client identifier and secret in variables

```shell script
code_client_id=$(echo $code_client | jq -r '.client_id')
```

```shell script
code_client_secret=$(echo $code_client | jq -r '.client_secret')
```

And perform an OAuth2 Authorize Code Flow

```shell script
docker-compose exec hydra \
    hydra perform authorization-code \
    --client-id $code_client_id \
    --client-secret $code_client_secret \
    --endpoint http://127.0.0.1:4444/ \
    --port 5555 \
    --scope openid --scope offline
```

And navigate to http://127.0.0.1:5555 in your browser

### Run tests

To run the tests, run the following command in the root of the project:

```
TBD
```

## Deploy

To use the example with Ory services self-hosted, you'll need to follow the Ory
installation guides for[ Ory Hydra](https://www.ory.sh/docs/hydra/install)
and[ Ory Kratos](https://www.ory.sh/docs/kratos/install).

To use the integration with an Ory Network project, sign up for an free
Developer account at [Ory Network](https://console.ory.sh/) and follow the
guides
for[Ory OAuth2](https://www.ory.sh/docs/getting-started/oauth2-openid/add-oauth2-openid-connect-nodejs-expressjs).
The integration is already implemented in the managed Ory Account Experience UI.

## Contribute

Feel free to
[open a discussion](https://github.com/ory/examples/discussions/new) to provide
feedback or talk about ideas, or
[open an issue](https://github.com/ory/examples/issues/new) if you want to add
your example to the repository or encounter a bug. You can contribute to Ory in
many ways, see the
[Ory Contributing Guidelines](https://www.ory.sh/docs/ecosystem/contributing)
for more information.
