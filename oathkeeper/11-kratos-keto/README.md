## Example using Ory Cloud with Ory Keto self-hosted

This example shows a basic configuration of `cookie_session` authenticator for
Ory Oathkeeper and `remote_json` for authorization.

## Develop

Ory Oathkeeper Access Rules: [`access-rules.yml`](./oathkeeper/access-rules.yml)
Ory Oathkeeper Configuration: [`oathkeeper.yml`](./oathkeeper/oathkeeper.yml)

For more information, please refer to
[the Ory Oathkeeper documentation](https://www.ory.sh/docs/oathkeeper)

### Prerequisites

1. [Docker](https://docs.docker.com/get-docker/)
1. [Ory Oathkeeper](https://www.ory.sh/docs/oathkeeper/install)
1. [Ory Keto](https://www.ory.sh/docs/keto/install)

### Run locally

```bash
   git clone git@github.com:ory/examples
   cd examples/oathkeeper/11_kratos_keto
   docker-compose up --build
   bash cli.sh
```

Wait for a couple of seconds and open `http://127.0.0.1:8080/hello`.

## Contribute

Feel free to
[open a discussion](https://github.com/ory/examples/discussions/new) to provide
feedback or talk about ideas, or
[open an issue](https://github.com/ory/examples/issues/new) if you want to add
your example to the repository or encounter a bug. You can contribute to Ory in
many ways, see the
[Ory Contributing Guidelines](https://www.ory.sh/docs/ecosystem/contributing)
for more information.
