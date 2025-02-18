FROM python:3.8-slim

WORKDIR /app

COPY ["Pipfile", "./"]
RUN pip install --no-cache pipenv
RUN pipenv install

COPY . .

EXPOSE 2992
EXPOSE 5001
CMD [ "pipenv", "run", "flask", "run", "-p", "5001", "-h", "0.0.0.0"]
