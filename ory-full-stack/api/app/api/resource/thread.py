from app.api.schema import ThreadSchema
from app.common import paginate
from app.extensions import db
from app.models import Thread
from flask import request
from flask_restful import Resource


class ThreadResource(Resource):
    def get(self, thread_id):
        schema = ThreadSchema()
        thread = Thread.query.get_or_404(thread_id)
        return {"thread": schema.dump(thread)}

    def put(self, thread_id):
        schema = ThreadSchema()
        thread = Thread.query.get_or_404(thread_id)
        thread = schema.load(request.json, instance=thread)

        db.session.commit()
        return {"thread": schema.dump(thread)}

    def delete(self, thread_id):
        thread = Thread.get_by_id(thread_id)
        thread.delete()
        return None, 204


class ThreadList(Resource):
    def get(self):
        schema = ThreadSchema(many=True)
        query = Thread.query
        return paginate(query, schema)

    def post(self):
        schema = ThreadSchema()
        thread = schema.load(request.json)
        thread.save()
        return {"thread": schema.dump(thread)}, 201
