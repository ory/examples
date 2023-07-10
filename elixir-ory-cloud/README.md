# Elixir Ory Cloud Example (Phoenix)

This is a basic Example of integrating [Ory](https://ory.sh) with [Phoenix](https://www.phoenixframework.org/). Highlighting a controller flow, using [plugs](https://hexdocs.pm/phoenix/plug.html) to render HEEx templates with session details, etc. 

## Getting Started

First build deps and setup Phoenix

```sh
$ mix deps.get && mix deps.compile
$ mix setup
```

### Configure your Ory Network/Kratos project
Set up your Custom UI to the following values:
|Custom UI|URL|
|---|---|
|Login UI|https://localhost:3000/auth/login|
|Registration UI|https://localhost:3000/auth/rgistration|

> NOTE: The other UIs are currently not implemented in this example.

### (If using Ory Network) Run the Ory Proxy
```sh
$ ory proxy http://localhost:4000 --dev --project $ORY_PROJECT  --port 3000 --cookie-domain localhost
```
