# Elixir Ory Cloud Phoenix Example
A basic Example of integrating [Ory](https://ory.sh) with [Phoenix](https://www.phoenixframework.org/). Highlighting a controller flow, using [plugs](https://hexdocs.pm/phoenix/plug.html) to render HEEx templates with session details, etc. 

## Overview

A simple server-side rendered web application serving Custom UI for Ory Flows. 

## Develop

### Prerequisites

[Elixir](https://elixir-lang.org/install.html) >= 1.14
[Erlang](https://www.erlang.org/downloads)
[Ory CLI](https://www.ory.sh/docs/guides/cli/installation)

### Configure your Ory Network/Kratos project
Set up your Custom UI to the following values:
| Custom UI       | URL                                     |
| --------------- | --------------------------------------- |
| Login UI        | https://localhost:3000/auth/login       |
| Register UI     | https://localhost:3000/auth/register    |

> NOTE: The other UIs are currently not implemented in this example.

### Environmental Variables

`$ORY_PROJECT` is used when running the Ory Proxy to prevent CORS issues.

### Run locally

First build the dependencies and setup Phoenix:

```sh
$ mix deps.get && mix deps.compile
$ mix setup
```

Start the Ory proxy for your `$ORY_PROJECT` slug in another shell
```sh
$ ory proxy http://localhost:4000 --dev --project $ORY_PROJECT  --port 3000 --cookie-domain localhost
```

And finally start serving the Phoenix server
```sh
$ mix phx.server
```

### Run tests

TODO: Integrate proper tests. :)

```sh
$ mix test
```

## Deploy

Most deployment mechanisms will work fine, such as [Fly.io](https://fly.io).

## Contribute

Feel free to
[open a discussion](https://github.com/ory/examples/discussions/new) to provide
feedback or talk about ideas, or
[open an issue](https://github.com/ory/examples/issues/new) if you want to add
your example to the repository or encounter a bug. You can contribute to Ory in
many ways, see the
[Ory Contributing Guidelines](https://www.ory.sh/docs/ecosystem/contributing)
for more information.

<!-- Optional: Add a personal note or sponsor link from the author here.-->
