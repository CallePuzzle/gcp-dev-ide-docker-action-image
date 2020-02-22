FROM python:3-slim

ENV APP_DIR $1

WORKDIR /app

COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]