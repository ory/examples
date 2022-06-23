from app.extensions import db
from app.extensions import ma
from app.models import Comment
from app.models import Thread


class CommentSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Comment
        sqla_session = db.session


class ThreadSchema(ma.SQLAlchemyAutoSchema):
    comments = ma.Nested(CommentSchema, many=True)

    class Meta:
        model = Thread
        sqla_session = db.session
