from config import settings
from flask import request
from flask import url_for
from flask_ory_auth.keto.client import AccessControl


DEFAULT_PAGE_SIZE = 50
DEFAULT_PAGE_NUMBER = 1


def extract_pagination(page=None, per_page=None, **request_args):
    page = int(page) if page is not None else DEFAULT_PAGE_NUMBER
    per_page = int(per_page) if per_page is not None else DEFAULT_PAGE_SIZE
    return page, per_page, request_args


def paginate(query, schema):
    page, per_page, other_request_args = extract_pagination(**request.args)
    page_obj = query.paginate(page=page, per_page=per_page)
    next_ = url_for(
        request.endpoint,
        page=page_obj.next_num if page_obj.has_next else page_obj.page,
        per_page=per_page,
        **other_request_args,
        **request.view_args,
    )
    prev = url_for(
        request.endpoint,
        page=page_obj.prev_num if page_obj.has_prev else page_obj.page,
        per_page=per_page,
        **other_request_args,
        **request.view_args,
    )

    return {
        "total": page_obj.total,
        "pages": page_obj.pages,
        "next": next_,
        "prev": prev,
        "results": schema.dump(page_obj.items),
    }

class AccessControlMixin:
    def __init__(self):
        self.keto_client = AccessControl(settings.KETO_WRITE_URL, settings.KETO_READ_URL)

    def is_allowed(self, namespace, obj, relation, subject_id):
        return self.keto_client.is_allowed(namespace, obj, relation, subject_id.replace("@", ""))
