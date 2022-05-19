## Oathkeeper+Nginx

This example shows an example of using Oathkeeper with Nginx

Request flow

1. Request lands on Nginx
2. Nginx uses subrequest authentication module and passes it to oathkeeper/decisions API
3. `cookie_sesion` authentication checks authentication and returns request back to Nginx
4. Hydrator adds an additional header to the request
5. Nginx proxies request to `hello` service

## Running locally

```
   git clone git@github.com:ory/examples
   cd examples/oathkeeper/02-authenticators
   docker-compose up
```

Wait for a couple of seconds and open `http://127.0.0.1:8080/hello`

You can find read configuration of [`access-rules.yml`](./oathkeeper/access-rules.yml) and
[`oathkeeper.yml`](./oathkeeper/oathkeeper.yml)
