import random
import string

import requests
from app.security import oauth2client
from config import settings
from flask import Blueprint
from flask import redirect
from flask import request
from flask import session


blueprint = Blueprint('public', __name__, url_prefix='/auth')
STRING_LENGTH = 32


@blueprint.route("/login")
def login():
    cfg = requests.get(settings.HYDRA_DISCOVERY_URL).json()

    state = generate_random_string()

    uri = oauth2client.prepare_request_uri(
        cfg['authorization_endpoint'], redirect_uri=settings.HYDRA_CALLBACK_URL, scope=settings.HYDRA_SCOPE, state=state
    )
    session['oauth2_state'] = state
    return redirect(uri)


@blueprint.route("/complete")
def complete():
    cfg = requests.get(settings.HYDRA_DISCOVERY_URL).json()

    token_url, headers, body = oauth2client.prepare_token_request(
        cfg["token_endpoint"],
        authorization_response=request.url,
        redirect_url=request.base_url,
        code=request.args.get('code'),
    )
    token_response = requests.post(
        cfg["token_endpoint"],
        headers=headers,
        data=body,
        auth=(settings.HYDRA_CLIENT_ID, settings.HYDRA_CLIENT_SECRET),
    )
    return token_response.json()


def generate_random_string():
    alphabet = string.ascii_lowercase + string.digits + string.ascii_uppercase
    return ''.join(random.choice(alphabet) for i in range(STRING_LENGTH))
