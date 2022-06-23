import json
import random
import string

import requests
from app.models import App
from app.public.forms import ConsentForm
from app.public.forms import LoginForm
from app.public.forms import Oauth2CreateForm
from app.security import oauth2
from config import settings
from flask import abort
from flask import Blueprint
from flask import redirect
from flask import render_template
from flask import request
from flask import session


bp = Blueprint('bp', __name__, url_prefix='/', template_folder='templates')
CLIENT_LENGTH = 32


@bp.route('/', methods=['GET'])
def index():
    return render_template('base.html')


@bp.route('/app/create', methods=['GET', 'POST'])
def create_oauth2_app():
    """View to create Oauth2 App."""
    form = Oauth2CreateForm(request.form)
    if request.method == 'POST' and form.validate():
        client_id = generate_client_id()
        resp = requests.post(
            f"{settings.HYDRA_ADMIN_URL}/clients",
            json={
                "client_id": client_id,
                "client_name": form.app_name.data,
                "grant_types": ["authorization_code", "refresh_token"],
                "redirect_uris": [form.callback_url.data],
                "response_types": ["code", "id_token"],
                "scope": settings.HYDRA_SCOPE,
            },
        )

        if resp.status_code != 201:
            # FIXME: Pass errors to the frontend
            return render_template('oauth/create_client.html', form=form)

        data = resp.json()
        app = App(
            name=form.app_name.data,
            description=form.description.data,
            website_url=form.website_url.data,
            client_id=client_id,
            client_secret=data.get('client_secret'),
            callback_url=form.callback_url.data,
            owner_id=session.get('user_id'),
        )
        app.save()
        return redirect('/apps', code=302)

    return render_template('oauth/create_client.html', form=form)


@bp.route('/app/<id>', methods=['GET'])
def app_detail():
    """App details view."""
    return render_template('oauth/list_client.html')


@bp.route('/apps', methods=['GET'])
def apps_list():
    """App list view."""
    apps = App.query.filter(App.owner_id == session.get('user_id'))
    return render_template('oauth/list_client.html', apps=apps)


@bp.route('/login', methods=['GET'])
def login():
    """Oauth2 login handler view."""
    form = LoginForm(request.args)
    if form.validate():
        data = oauth2.get_login_request(form.login_challenge.data)
        traits = json.loads(session.get('traits'))
        traits["user_id"] = session.get("kratos_id")

        data = oauth2.accept_login_request(form.login_challenge.data, json.dumps(traits))
        return redirect(data.get('redirect_to'), code=302)

    return redirect(f"{settings.KRATOS_UI_URL}/login", code=302)


@bp.route('/consent', methods=['GET', 'POST'])
def consent():
    """Oauth2 consent view."""
    form = ConsentForm(request.form)
    if request.method == 'POST' and form.validate():
        data = oauth2.get_consent_request(form.consent_challenge.data)

        if form.submit.data == 'accept':
            accept = oauth2.accept_consent_request(
                form.consent_challenge.data,
                data.get('requested_scope'),
                session.get('email'),
            )
            return redirect(accept.get('redirect_to'), code=302)

        if form.submit.data == 'reject':
            reject = oauth2.reject_consent_request(
                form.consent_challenge.data,
            )
            return redirect(reject.get('redirect_to'), code=302)

    challenge = request.args.get('consent_challenge')
    if not challenge:
        abort(403)

    data = oauth2.get_consent_request(challenge)
    app = App.query.filter(App.client_id == data.get('client').get('client_id')).first()
    scopes = eval(data.get('requested_scope').to_str())

    return render_template('oauth/consent.html', app=app, scopes=scopes, challenge=challenge)


def generate_client_id():
    alphabet = string.ascii_lowercase + string.digits + string.ascii_uppercase
    return ''.join(random.choice(alphabet) for i in range(CLIENT_LENGTH))
