# Ory Action to check IP addresses against vpnapi.io

This is an example Action (webhook) to check client IP addresses against
vpnapi.com and block requests

- coming from TOR clients
- coming from known VPNs
- coming from certain geographies (in this example: RU)

It's intended for use as a post-login Action on Ory Network and returns a
message that can be parsed by Ory and displayed to the user.

The example implementation is written in Python with Flask for deployment on GCP
Cloud Functions, and can easily be adapted for different scenarios.

## How to run it

### You'll need

Accounts:

- A Google Cloud project with Cloud Functions active (or an alternate way to
  deploy)
- A vpnapi.com account

For Development:

- python 3.9+
- flask
- requests
- google cloud logging

To install dependencies, run e.g.

```bash
    pip3 install google-cloud-logging
```

### Run locally

```bash
    export BEARER_TOKEN=SOME_SECRET_API_KEY_FOR_YOUR_WEBHOOK;
    export VPNAPIIO_API_KEY=YOUR_VPNAPI_KEY;
    python3 main.py
```

### Send a sample request

```bash
curl -X POST \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_WEBHOOK_API_SECRET" \
     -d '{"ip_address": "8.8.8.8"}' \
     http://localhost:5000/vpncheck -v
```

For blocked requests, you'll get `HTTP 400` responses with a payload like

```json
{ "messages": [{ "messages": [{ "text": "Request blocked: VPN" }] }] }
```

When successful, you'll get a `HTTP 200` response.

## Deploy to GCP

After setting up your GCP project (see, for example,
[this guide](https://cloud.google.com/functions/docs/create-deploy-http-python)),
you can deploy the Action as a cloud function:

```bash
    gcloud functions deploy vpncheck --runtime python39 --trigger-http --allow-unauthenticated --set-env-vars BEARER_TOKEN=$SOME_SECRET_API_KEY_FOR_YOUR_WEBHOOK,VPNAPIIO_API_KEY=$VPNAPIIO_API_KEY,ENABLE_CLOUD_LOGGING=true --source=.
```

Note: You may need to create a `venv` for dependencies to load correctly.

You'll receive an endpoint address, which you can plug into the `curl` command
above. On Google's Cloud Console, you can also see logs to verify it's working
as intended.

## Integrating with Ory

To set up your Ory Network project to use the Action, go to Ory Console >
Developers > Actions and create a new post-login webhook:

![Console Actions Screen](docs/images/actions-console-2.png)

Configure it for the Login flow, select "After" execution, and POST as the
method, and enter your deployed URL.

Because we want the Action to cancel logins from disallowed IP addresses, we
need to run in synchronous. Enabling `parse response` allows us to show a nice
error message to users, rather than a system error.

![Console Actions Screen](docs/images/actions-console-1.png)

On the second screen, configure authentication with `Key`, select `Header` as
the transport mode and put in your API key in the format
`Bearer: $SOME_SECRET_API_KEY_FOR_YOUR_WEBHOOK` as the key value. You can of
course use other ways to authenticate - this is just how the example implemented
a basic check.

Our webhook expects a simple payload with just an `ip_address` field. We can get
the IP address from the context with a simple JSONNET transformation:

```javascript
    function(ctx) {
        ip_address: ctx.request_headers['True-Client-Ip'][0],
    }
```

![Console Actions Screen](docs/images/actions-console-3.png)

## Seeing it in action

With everything set up, we can test the behavior using the Ory Account
Experience. When logging in via VPN, the request now gets blocked and the
message is shown to users!

![Account Experience displaying error](docs/images/ax-with-message.png)
