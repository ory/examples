## An example using Ory Cloud with Ory Keto

This example shows basic configuration of `cookie_session` authenticator for oathkeeper and `remote_json` for authorization

## Running locally

```
   git clone git@github.com:ory/examples
   cd examples/oathkeeper/12_ory_cloud_keto
   docker-compose up
```

## Running Ory proxy

```
   ory proxy http://127.0.0.1:8080
```

## Configuring Ory Keto Cloud

1. Edit `cli.sh` and put your personal access token and change the URL of your Ory instance
1. Run it `bash cli.sh`

## Configuring oathkeeper

Replace URLs with your own

## Testing it

Open `http://127.0.0.1:4000/ui/login` and login
Open `http://127.0.0.1:8080/hello`

You can find read configuration of [`access-rules.yml`](./oathkeeper/access-rules.yml) and
[`oathkeeper.yml`](./oathkeeper/oathkeeper.yml)
