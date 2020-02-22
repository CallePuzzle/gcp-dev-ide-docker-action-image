FROM python:3-slim

RUN apt-get update \
      apt-get install ansible terraform python-pip

RUN pip install requests google-auth

ENV APP_DIR $1

WORKDIR /app

COPY entrypoint.sh /app/entrypoint.sh
COPY src/ /app/

ENTRYPOINT ["entrypoint.sh"]