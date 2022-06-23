FROM python:3.10-slim-buster

WORKDIR /python-docker

RUN pip3 install poetry
COPY . .

RUN poetry install

CMD [ "/python-docker/entrypoint.sh" ]
