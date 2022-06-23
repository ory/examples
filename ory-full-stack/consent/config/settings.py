"""Application configuration.

Most configuration is set via environment variables.

For local development, use a .env file to set
environment variables.
"""
from environs import Env

env = Env()
env.read_env()

DEBUG = True

# KRATOS_API_URL stores URL to Kratos public API.
# Specify https://<project-slug>.projects.oryapis.com
# to use it against Ory Cloud
KRATOS_API_URL = env.str("KRATOS_API_URL", default='http://127.0.0.1:4433')

# KRATOS_UI_URL is an URL for the UI frontend for Ory Kratos
# Specify https://<project-slug>.projects.oryapis.com/ui
# to use it against Ory Cloud
KRATOS_UI_URL = env.str("KRATOS_UI_URL", default='http://127.0.0.1:4455')

# SQLALCHEMY_DATABASE_URI is an URI for the database
# connection.
#
# MySQL: mysql://root:root@localhost/database
SQLALCHEMY_DATABASE_URI = env.str("SQLALCHEMY_DATABASE_URI", default='sqlite:////tmp/db.sqlite3')

# HYDRA_ADMIN_URL stores URL to Hydra admin API.
HYDRA_ADMIN_URL = env.str("HYDRA_ADMIN_URL", default='http://127.0.0.1:4445')

# HYDRA_PUBLIC_URL stores URL to Hydra public API.
HYDRA_PUBLIC_URL = env.str("HYDRA_PUBLIC_URL", default='http://127.0.0.1:4444')

# SECRET_KEY is generated 32bit key
SECRET_KEY = env.str("SECRET_KEY", default='not_secure_at_all')

# HYDRA_SCOPE is variable to configure Oauth2 scopes
HYDRA_SCOPE = env.str("HYDRA_SCOPE", default="openid offline")
