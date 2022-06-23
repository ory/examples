import pytest


@pytest.fixture(scope="session")
def app():
    """Create application for the tests."""
    _app = create_app("config.test")

    _app.logger.setLevel(logging.CRITICAL)
    ctx = _app.test_request_context()
    ctx.push()
    yield _app
    ctx.pop()


@pytest.fixture(scope="session")
def db(app, request):
    """Create database for the tests."""
    _db.app = app

    with app.app_context():
        flask_migrate.upgrade()

    def teardown():
        # Explicitly close DB connection
        close_all_sessions()
        _db.drop_all()
        _db.engine.execute("DROP TABLE alembic_version")

    yield _db
    teardown()


@pytest.fixture(autouse=True)
def session(db, flask_session):
    """Create a new database session for a test."""
    if not flask_session.get('user_id'):
        flask_session['user_id'] = DEFAULT_SESSION_USER_ID

    connection = db.engine.connect()
    transaction = connection.begin()

    options = {"bind": connection, "binds": {}}
    session = db.create_scoped_session(options=options)

    db.session = session

    def teardown():
        transaction.rollback()
        connection.close()
        session.expunge_all()
        session.close()
        session.remove()

    yield session
    teardown()
