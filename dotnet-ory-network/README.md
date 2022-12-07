# Secure an ASP.NET Core application using Ory Network

This repo demonstrates how you can use Ory Network or Ory Kratos with ASP.NET Core apps.
This app is not for production use and serves as an example of integration.

## Overview

Generated using the default `dotnet new mvc` command.

## Develop

### Prerequisites

1. [dotnet sdk 7.0](https://dotnet.microsoft.com/en-us/download/dotnet/7.0)
1. [Ory cli](https://www.ory.sh/docs/guides/cli/installation) - Used for [tunneling](https://www.ory.sh/docs/guides/cli/proxy-and-tunnel#ory-tunnel) traffic
1. [Docker](https://docs.docker.com/get-docker/) (if you want to self-host Ory Kratos)

Alternatively you can used the provided [devcontainer](https://containers.dev/overview) which comes with dotnet sdk and ory-cli preinstalled.

## Run locally

Add the localhost endpoint to the list of allowed urls:
```bash
ory patch project <your-project-id> \
  --replace '/services/identity/config/selfservice/allowed_return_urls=["http://localhost:5286/"]'
```

Start an Ory Tunnel:
```bash
ory tunnel --dev --project <your-project-slug> http://localhost:5286
```

Run the app:
```bash
dotnet run ./src/ExampleApp
```

Open http://localhost:5286 for testing

## Contribute

Feel free to
[open a discussion](https://github.com/ory/examples/discussions/new) to provide
feedback or talk about ideas, or
[open an issue](https://github.com/ory/examples/issues/new) if you want to add
your example to the repository or encounter a bug. You can contribute to Ory in
many ways, see the
[Ory Contributing Guidelines](https://www.ory.sh/docs/ecosystem/contributing)
for more information.
