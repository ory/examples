from app.extensions import db
from app.models import constants
from app.models.base import PkModel


class SubReddit(PkModel):
    __tablename__ = 'subreddits'
    name = db.Column(db.String(constants.MAX_NAME), unique=True)
    desc = db.Column(db.String(constants.MAX_DESCRIPTION))

    admin_id = db.Column(db.Integer, db.ForeignKey('users.id'))

    threads = db.relationship('Thread', backref='subreddit', lazy='dynamic')
    status = db.Column(db.SmallInteger, default=constants.ALIVE)
