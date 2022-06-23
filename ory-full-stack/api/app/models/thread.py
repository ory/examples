from app.extensions import db
from app.models import constants
from app.models.base import PkModel


thread_upvotes = db.Table(
    'thread_upvotes',
    db.Column('user_id', db.Integer, db.ForeignKey('users.id')),
    db.Column('thread_id', db.Integer, db.ForeignKey('threads.id')),
)

comment_upvotes = db.Table(
    'comment_upvotes',
    db.Column('user_id', db.Integer, db.ForeignKey('users.id')),
    db.Column('comment_id', db.Integer, db.ForeignKey('threads.id')),
)


class Thread(PkModel):
    __tablename__ = 'threads'

    title = db.Column(db.String(constants.MAX_TITLE))

    text = db.Column(db.String(constants.MAX_BODY))
    link = db.Column(db.String(constants.MAX_LINK))

    thumbnail = db.Column(db.String(constants.MAX_LINK))

    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    status = db.Column(db.SmallInteger, default=constants.ALIVE)
    subreddit_id = db.Column(db.Integer, db.ForeignKey('subreddits.id'))

    comments = db.relationship('Comment', backref='thread', lazy='dynamic')

    votes = db.Column(db.Integer, default=1)


class Comment(PkModel):
    __tablename__ = 'comments'

    id = db.Column(db.Integer, primary_key=True)
    author_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    text = db.Column(db.String(constants.MAX_BODY))

    thread_id = db.Column(db.Integer, db.ForeignKey('threads.id'))
    parent_id = db.Column(db.Integer, db.ForeignKey('comments.id'))
    children = db.relationship('Comment', backref=db.backref('parent', remote_side=id), lazy='dynamic')
    depth = db.Column(db.Integer, default=1)

    votes = db.Column(db.Integer, default=1)
