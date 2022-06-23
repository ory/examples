from app.api.schema import CommentSchema
from app.common import paginate
from app.extensions import db
from app.models import Comment
from flask import request
from flask_restful import Resource


class CommentResource(Resource):
    def get(self, comment_id):
        schema = CommentSchema()
        comment = Comment.query.get_or_404(comment_id)
        return {"comment": schema.dump(comment)}

    def put(self, comment_id):
        schema = CommentSchema()
        comment = Comment.query.get_or_404(comment_id)
        comment = schema.load(request.json, instsance=comment)

        db.session.commit()

        return {"comment": schema.dump(comment)}

    def delete(self, comment_id):
        comment = Comment.get_by_id(comment_id)
        comment.delete()
        return None, 204


class CommentList(Resource):
    def get(self):
        schema = CommentSchema(many=True)
        query = Comment.query
        return paginate(query, schema)

    def post(self):
        schema = CommentSchema()
        comment = schema.load(request.json)
        comment.save()
        return {"comment": schema.dump(comment)}, 201
