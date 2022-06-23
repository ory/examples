import enum

from app.extensions import db
from app.models.base import PkModel


class UserRole(enum.Enum):
    USER = "user"
    MODERATOR = "moderator"
    ADMIN = "admin"


class User(PkModel):
    __tablename__ = 'users'
    kratos_id = db.Column(db.String(36))
    email = db.Column(db.String())

    role = db.Column(db.Enum(UserRole), default=UserRole.USER)

    threads = db.relationship('Thread', backref='user', lazy='dynamic')
    comments = db.relationship('Comment', backref='user', lazy='dynamic')
    subreddits = db.relationship('SubReddit', backref='user', lazy='dynamic')
