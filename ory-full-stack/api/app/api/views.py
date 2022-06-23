import json

import requests
from app.api.resource import CommentList
from app.api.resource import CommentResource
from app.api.resource import SubRedditList
from app.api.resource import SubRedditResource
from app.api.resource import ThreadList
from app.api.resource import ThreadResource
from app.api.schema import CommentSchema
from app.api.schema import SubRedditSchema
from app.api.schema import ThreadSchema
from app.extensions import apispec
from config import settings
from flask import Blueprint
from flask import current_app
from flask import jsonify
from flask import redirect
from flask import request
from flask import session
from flask_restful import Api
from marshmallow import ValidationError


blueprint = Blueprint("api", __name__, url_prefix="/api/v1")
api = Api(blueprint)


api.add_resource(ThreadResource, "/threads/<int:thread_id>", endpoint="thread_by_id")
api.add_resource(ThreadList, "/threads", endpoint="threads")

api.add_resource(CommentResource, "/threads/<int:comment_id>", endpoint="comment_by_id")
api.add_resource(CommentList, "/comments", endpoint="comments")

api.add_resource(SubRedditResource, "/subreddits/<int:subreddit_id>", endpoint="subreddit_by_id")
api.add_resource(SubRedditList, "/subreddits", endpoint="subreddits")


@blueprint.before_app_first_request
def register_views():
    apispec.spec.components.schema("ThreadSchema", schema=ThreadSchema)
    apispec.spec.path(view=ThreadResource, app=current_app)
    apispec.spec.path(view=ThreadList, app=current_app)

    apispec.spec.components.schema("CommentSchema", schema=CommentSchema)
    apispec.spec.path(view=CommentResource, app=current_app)
    apispec.spec.path(view=CommentList, app=current_app)

    apispec.spec.components.schema("SubRedditSchema", schema=SubRedditSchema)
    apispec.spec.path(view=SubRedditResource, app=current_app)
    apispec.spec.path(view=SubRedditList, app=current_app)


@blueprint.errorhandler(ValidationError)
def handle_marshmallow_error(e):
    """Return json error for marshmallow validation errors.
    This will avoid having to try/catch ValidationErrors in all endpoints, returning
    correct JSON response with associated HTTP 400 Status (https://tools.ietf.org/html/rfc7231#section-6.5.1)
    """
    return jsonify(e.messages), 400


@blueprint.before_request
def introspect():
    token = get_access_token(request)
    if not token:
        return redirect(settings.OAUTH2_LOGIN_URL, code=302)

    resp = requests.post(
        f"{settings.HYDRA_ADMIN_URL}/oauth2/introspect",
        data={
            "scope": settings.HYDRA_SCOPE,
            "token": token,
        },
    )
    traits = json.loads(resp.json().get('sub'))

    if resp.status_code != 200:
        return redirect(settings.OAUTH2_LOGIN_URL, code=302)

    session['email'] = traits.get('email')
    session['user_id'] = traits.get('user_id')


def get_access_token(request):
    header = request.headers.get("Authorization")
    if not header:
        access_token = request.args.get("access_token", "")
        if access_token:
            return access_token

        access_token = request.form.get("access_token", "")
        if access_token:
            return access_token

        return None

    parts = header.split()
    return parts[1]
