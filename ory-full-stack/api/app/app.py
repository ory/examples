import random
import string

from app import api
from app import public
from app.extensions import apispec
from app.extensions import db
from app.extensions import migrate
from flask import Flask
from flask import session


def create_app(testing=False):
    """Application factory, used to create application."""
    app = Flask(__name__)
    app.config.from_object("config.settings")
    if testing:
        app.config["TESTING"] = True

    configure_extensions(app)
    configure_apispec(app)
    register_blueprints(app)
    set_context_processor(app)

    return app


def configure_extensions(app):
    """Configure flask extensions."""

    db.init_app(app)
    migrate.init_app(app, db)


def configure_apispec(app):
    """Configure APISpec for swagger support"""
    apispec.init_app(app, security=[{"jwt": []}])
    apispec.spec.components.security_scheme("jwt", {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"})
    apispec.spec.components.schema(
        "PaginatedResult",
        {
            "properties": {
                "total": {"type": "integer"},
                "pages": {"type": "integer"},
                "next": {"type": "string"},
                "prev": {"type": "string"},
            }
        },
    )


def register_blueprints(app):
    app.register_blueprint(public.views.blueprint)
    app.register_blueprint(api.views.blueprint)


def set_context_processor(app):
    """Set context processor for app."""

    def generate_state(self):
        alphabet = string.ascii_lowercase + string.digits + string.ascii_uppercase
        return ''.join(random.choice(alphabet) for i in range(32))

    @app.context_processor
    def set_email_session():
        state = generate_state()
        session['oauth2_state'] = state

        return {
            "oauth2_state": session.get("oauth2_state"),
        }
