# Securing Django application using Ory example

This repo demonstrates how you can use Ory Cloud or Ory Kratos with Django apps.
This app is not for production use and serves as an example of integration.
It was generated using the default `django-admin startproject` command. It uses sqlite3 as the database backend.
Consider using [django-cookiecutter](https://github.com/cookiecutter/cookiecutter-django)

## Prerequisites

1. Python 3.10
2. [Poetry](https://python-poetry.org/) - Python dependency manager.
3. Docker (if you want to  self-host Ory Kratos)

## Running locally

```
   git clone git@github.com:ory/examples
   cd examples/django-ory-cloud
   poetry install
   cd mysite
   poetry run python manage.py migrate
   poetry run python manage.py runserver

```

## Environment variables

```
export ORY_SDK_URL=https://playground.projects.oryapis.com
export ORY_UI_URL=https://playground.projects.oryapis.com/ui
```

Open http://127.0.0.1:8000 for testing

