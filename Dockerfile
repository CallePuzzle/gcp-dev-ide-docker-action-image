FROM python:3-slim

ARG INPUT_SA_KEY

WORKDIR /app

COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]