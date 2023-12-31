# ORY Hydra Next.js Reference Implementation (TypeScript)

This is a Next.js app which sets up a OAuth 2.0 and OpenID Connect Provider using [Ory Hydra](https://www.ory.sh/docs/hydra/) as a backend. It has an unstyled UI and doesn't implement user management but can be easily modified to fit into your existing system.

# Features

  * User login, logout, registration, consent
  * CSRF protection with [edge-csrf](https://github.com/amorey/edge-csrf)
  * Super-strict HTTP security headers (configurable)
  * Client-side JavaScript disabled by default
  * Unit tests with Jest
  * E2E tests with Cypress
  * Start/stop Hydra in development using docker-compose
  * Easily customizable
  * Written in TypeScript

## Configuration

This application can be configured using the following environment variables:

| Name                    | Default                |
| ----------------------- | ---------------------- |
| SECURITY_HEADERS_ENABLE | false                  |
| HYDRA_ADMIN_URL         | http://localhost:4445/ |

## Development

To install dependencies:

```sh
yarn install
```

To run the Next.js app server in development mode:

```sh
yarn dev
```

To start/stop hydra in development you can use the docker-compose file found in the `ory/` directory:

```sh
# start
docker compose -f ory/docker-compose.yml up -d

# stop
docker compose -f ory/docker-compose.yml down

# stop and remove mounted volumes
docker compose -f ory/docker-compose.yml down -v
docker compose -f ory/docker-compose.yml rm -fsv
```

## Production

To run the app in production first run the `build` command then run `start`:

```sh
yarn build
yarn start
```

## Testing

To run the unit tests (using Jest):

```sh
yarn test
```

To run the E2E tests (using Cypress):

```sh
yarn build
yarn test-e2e
```
