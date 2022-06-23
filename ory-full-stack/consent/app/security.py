from config import settings
from flask_ory_auth.hydra.client import HydraClient
from flask_ory_auth.kratos.client import Authentication

authentication = Authentication(settings.KRATOS_API_URL)
oauth2 = HydraClient(settings.HYDRA_ADMIN_URL, settings.HYDRA_PUBLIC_URL)
