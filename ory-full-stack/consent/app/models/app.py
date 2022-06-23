from app.extensions import db
from app.models.base import PkModel


class App(PkModel):
    __tablename__ = 'apps'

    name = db.Column(db.String())
    description = db.Column(db.String())
    website_url = db.Column(db.String())
    client_id = db.Column(db.String())
    client_secret = db.Column(db.String())
    callback_url = db.Column(db.String())
    owner_id = db.Column(db.Integer, db.ForeignKey('users.id'))
