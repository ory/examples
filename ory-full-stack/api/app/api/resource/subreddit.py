from app.api.schema import SubRedditSchema
from app.common import AccessControlMixin
from app.common import paginate
from app.extensions import db
from app.models import SubReddit
from flask import abort
from flask import request
from flask import session
from flask_restful import Resource


class SubRedditResource(Resource, AccessControlMixin):
    def get(self, subreddit_id):
        schema = SubRedditSchema()
        subreddit = SubReddit.query.get_or_404(subreddit_id)
        return {"subreddit": schema.dump(subreddit)}

    def put(self, subreddit_id):
        user_id = session.get("user_id")
        if not self.is_allowed("app", "subreddit", "edit", user_id):
            return abort(403)

        schema = SubRedditSchema()
        subreddit = SubReddit.query.get_or_404(subreddit_id)
        subreddit = schema.load(request.json, instsance=subreddit)

        db.session.commit()

        return {"subreddit": schema.dump(subreddit)}

    def delete(self, subreddit_id):
        user_id = session.get("email")
        if not self.is_allowed("app", "subreddit", "delete", user_id):
            return abort(403)

        subreddit = SubReddit.get_by_id(subreddit_id)
        subreddit.delete()
        return None, 204


class SubRedditList(Resource, AccessControlMixin):
    def get(self):
        schema = SubRedditSchema(many=True)
        query = SubReddit.query
        return paginate(query, schema)

    def post(self):
        user_id = session.get("email")
        if not self.is_allowed("app", "subreddit", "create", user_id):
            return abort(403)

        schema = SubRedditSchema()
        subreddit = schema.load(request.json)
        subreddit.save()
        return {"subreddit": schema.dump(subreddit)}, 201
