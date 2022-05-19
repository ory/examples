# Kong + Ory Kratos + Ory Oathkeeper showcase

This is a demo app build to show a configuration using these products to build your next app

## Architecture

1. A simple Go HTTP API that exposes `/greet` endpoint and listens `:8090` port
2. Oathkeeper as Zero Trust Identity Access Proxy
3. Kong as an ingress for incoming HTTP traffic

## Configure local environment

### Prerequisites

1. Go 1.1x
2. Docker
3. make

### Using docker-compose

```
docker-compose up --build
```

That command builds go webserver and runs all services and exposes the following ports

1. HTTP `:8001` and SSL `:8444` ports for Kong Gateway admin API
2. HTTP `:8000` and SSL `:8444` ports for Kong Gateway Proxy listener
3. HTTP `:4433` and `:4434` are public and admin API's of Ory Kratos
4. HTTP `:4436` for Mailslurper
5. HTTP `:4455` for UI interface

## A request flow

User -> Kong -> Oathkeeper -> Kratos -> Go API

## Configuring Kong

```
bash config.kong.sh

```

That command creates an `/greet` endpoint on `secure-api` service and creates a reverse proxy for oathkeeper

## Oathkeeper

Oathkeeper checks the incoming request for presense of `ory_kratos_session` and do the following steps

1. Proxies request to Go HTTP API if the identity check passes in Ory Kratos
2. Redirects user to the Kratos UI if the identity check fails

## Local demo

```
docker-compose up --build
```

Open http://127.0.0.1:8000/hello in your browser and follow the login flow
