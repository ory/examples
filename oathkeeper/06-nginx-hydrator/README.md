# An example using Nginx with Oathkeeper as decision API

This example shows an example of using Oathkeeper with Nginx and hydrator mutator

Request flow

1. Request lands on Nginx
1. Nginx uses subrequest authentication module and passes it to oathkeeper/decisions API
1. `cookie_sesion` authentication checks authentication
1. Makes request to `hydrator` service and adds `X-User-Name` header
1. Nginx proxies request to `hello` service with `X-User: user_id`, `X-user-Name: andrew` headers

## Running locally

```
   git clone git@github.com:ory/examples
   cd examples/oathkeeper/06-nginx-hydrator
   docker-compose up
```

Wait for a couple of seconds and open `http://127.0.0.1:8080/hello`

You can find read configuration of [`access-rules.yml`](./oathkeeper/access-rules.yml) and
[`oathkeeper.yml`](./oathkeeper/oathkeeper.yml)

## Contribute

Feel free to [open a discussion](https://github.com/ory/examples/discussions/new) to provide feedback or talk about ideas, or [open an issue](https://github.com/ory/examples/issues/new) if you want to add your example to the repository or encounter a bug.
You can contribute to Ory in many ways, see the [Ory Contributing Guidelines](https://www.ory.sh/docs/ecosystem/contributing) for more information.

