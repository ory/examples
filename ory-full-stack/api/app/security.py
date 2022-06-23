from config import settings
from oauthlib.oauth2 import WebApplicationClient


oauth2client = WebApplicationClient(settings.HYDRA_CLIENT_ID)
