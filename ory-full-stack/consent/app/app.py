from app import public
from app.extensions import db
from app.extensions import migrate
from app.security import authentication
from config import settings
from flask import Flask
from flask import session
from flask_ory_auth.kratos.middleware import AuthenticationMiddleware


def create_app(testing=False):
    """Application factory, used to create application."""
    app = Flask(__name__)
    app.config.from_object("config.settings")
    if testing:
        app.config["TESTING"] = True

    if settings.KRATOS_API_URL and settings.KRATOS_UI_URL:
        app.wsgi_app = AuthenticationMiddleware(app.wsgi_app, settings.KRATOS_API_URL, settings.KRATOS_UI_URL)

    configure_extensions(app)
    register_blueprints(app)
    set_context_processor(app)

    return app


def configure_extensions(app):
    """Configure flask extensions."""

    db.init_app(app)
    migrate.init_app(app, db)


def register_blueprints(app):
    app.register_blueprint(public.views.bp)


def set_context_processor(app):
    """Set context processor for app."""

    @app.context_processor
    def set_email_session():
        """Set kratos email session."""
        authentication.set_user_to_session(session)

        return {
            "user": session.get("email"),
        }
