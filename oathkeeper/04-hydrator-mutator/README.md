## An example using Oathkeeper with cookie session authenticator and hydrator mutator

This example shows basic configuration of `cookie_session` authenticator with `hydrator` mutator for oathkeeper.

It implements the following flow

1. Validates incoming requests using `cookie_session` authenticator
2. Modifies request and sends `X-User` with value returned on previous step
3. Makes request to `hydrator` service and adds `X-User-Name` header
4. Sends only authenticated request to `hello` microservice with `X-User: user_id`, `X-User-Name: andrew` headers

## Running locally

```
   git clone git@github.com:ory/examples
   cd examples/oathkeeper/04-hydrator-mutator
   docker-compose up
```

### Prerequisites

1. Docker


Wait for a couple of seconds and open `http://127.0.0.1:8080/hello`

You can find read configuration of [`access-rules.yml`](./oathkeeper/access-rules.yml) and
[`oathkeeper.yml`](./oathkeeper/oathkeeper.yml)

## Contribute

Feel free to [open a discussion](https://github.com/ory/examples/discussions/new) to provide feedback or talk about ideas, or [open an issue](https://github.com/ory/examples/issues/new) if you want to add your example to the repository or encounter a bug.
You can contribute to Ory in many ways, see the [Ory Contributing Guidelines](https://www.ory.sh/docs/ecosystem/contributing) for more information.

