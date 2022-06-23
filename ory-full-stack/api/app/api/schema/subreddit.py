from app.extensions import db
from app.extensions import ma
from app.models import SubReddit


class SubRedditSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = SubReddit
        load_instance = True
        sqla_session = db.session
