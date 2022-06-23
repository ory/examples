"""Application configuration.

Most configuration is set via environment variables.

For local development, use a .env file to set
environment variables.
"""
from environs import Env

env = Env()
env.read_env()

DEBUG = True
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

# HYDRA_CLIENT_ID is an ID of created oauth2 client at auth service
HYDRA_CLIENT_ID = env.str("HYDRA_CLIENT_ID", default='i4GGX1fWnEYvCu2Vo2iHdubzFYg7codg')

# HYDRA_CLIENT_SECRET is client secred of created oauth2 client at auth service
HYDRA_CLIENT_SECRET = env.str("HYDRA_CLIENT_SECRET", default='D.rDsGphHoaP157ecROt92~QI5')

OAUTH2_LOGIN_URL = env.str("OAUTH2_LOGIN_URL", default='http://127.0.0.1:5000/login')

HYDRA_CALLBACK_URL = env.str("HYDRA_CALLBACK_URL", default='http://127.0.0.1:5000/complete')

# HYDRA_DISCOVERY_URL is an URL to openid-configuration
HYDRA_DISCOVERY_URL = env.str("HYDRA_DISCOVERY_URL", default='http://127.0.0.1:4444/.well-known/openid-configuration')

# HYDRA_SCOPE is variable to configure Oauth2 scopes
HYDRA_SCOPE = env.str("HYDRA_SCOPE", default="openid offline")

# KRATOS_UI_URL is an URL for the UI frontend for Ory Kratos
# Specify https://<project-slug>.projects.oryapis.com/ui
# to use it against Ory Cloud
KRATOS_UI_URL = env.str("KRATOS_UI_URL", default='http://127.0.0.1:4455')

KETO_WRITE_URL = env.str("KETO_WRITE_URL", default="http://127.0.0.1:4466")
KETO_READ_URL = env.str("KETO_READ_URL", default="http://127.0.0.1:4466")
