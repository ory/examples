from datetime import datetime

from app.extensions import db


class CRUDMixin:
    """Mixin that adds convenience methods for CRUD (create, read, update, delete) operations."""

    @classmethod
    def create(cls, **kwargs):
        """Create a new record and save it the database."""
        instance = cls(**kwargs)
        return instance.save()

    def update(self, commit=True, **kwargs):
        """Update specific fields of a record."""
        for attr, value in kwargs.items():
            setattr(self, attr, value)
        return commit and self.save() or self

    def save(self):
        """Save the record."""
        db.session.add(self)
        db.session.commit()
        print("COMMIT", flush=True)
        db.session.flush()
        return self

    def delete(self, commit=True):
        """Soft delete the record in the database."""
        self.deleted = datetime.utcnow()
        db.session.add(self)
        return commit and db.session.flush()


class Model(CRUDMixin, db.Model):
    """Base model class that includes CRUD convenience methods."""

    __abstract__ = True


class PkModel(Model, CRUDMixin):
    """Base model class that includes CRUD convenience methods, plus adds a 'primary key' column named ``id``."""

    __abstract__ = True
    id = db.Column(db.Integer, primary_key=True)
    created_on = db.Column(db.DateTime, default=db.func.now())
    updated_on = db.Column(db.DateTime, default=db.func.now(), onupdate=db.func.now())
    deleted = db.Column(db.DateTime, nullable=True)

    @classmethod
    def get_by_id(cls, record_id):
        """Get record by ID."""
        if any(
            (
                isinstance(record_id, str) and record_id.isdigit(),
                isinstance(record_id, (int, float)),
            )
        ):
            return cls.query.get(int(record_id))
        return None

    @classmethod
    def get_list(cls):
        """Get the list of records without sofly deleted."""
        return cls.query.filter(cls.deleted.__eq__(None)).all()

    @classmethod
    def default_query(cls):
        """Return not deleted models."""
        return cls.query.filter(cls.deleted.is_(None))
