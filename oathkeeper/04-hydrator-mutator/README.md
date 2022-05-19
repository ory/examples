## An example using Oathkeeper with cookie session authenticator

This example shows basic configuration of `cookie_session` authenticator with `header` mutator for oathkeeper.

It implements the following flow

1. Validates incoming requests using `cookie_session` authenticator
2. Modifies request and sends `X-User` with value returned on previous step
3. Makes request to `hydrator` service and adds `X-User-Name` header
4. Sends only authenticated request to `hello` microservice with `X-User: user_id`, `X-User-Name: andrew` headers

## Running locally

```
   git clone git@github.com:ory/examples
   cd examples/oathkeeper/02-authenticators
   docker-compose up
```

Wait for a couple of seconds and open `http://127.0.0.1:8080/hello`

You can find read configuration of [`access-rules.yml`](./oathkeeper/access-rules.yml) and
[`oathkeeper.yml`](./oathkeeper/oathkeeper.yml)
