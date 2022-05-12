## Traefik and oahtkeeper

This example shows an example of using Oathkeeper with Traefik

Request flow

1. Request lands on Traefik
1. Traefik uses forwardauth to forward authentication to http://oathkeeper/decision API
1. `cookie_sesion` authentication checks authentication and returns request back to Traefik
1. Hydrator adds an additional header to the request
1. Traefik proxies request to `hello` service

## Running locally


```
   git clone git@github.com:ory/examples
   cd examples/oathkeeper/02-authenticators
   docker-compose up
```

Wait for a couple of seconds and open `http://127.0.0.1:8080/hello`

You can find read configuration of [`access-rules.yml`](./oathkeeper/access-rules.yml) and [`oathkeeper.yml`](./oathkeeper/oathkeeper.yml)
