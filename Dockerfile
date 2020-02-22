FROM python:3-slim


ARG INPUT_SA_KEY
ARG INPUT_PROJECT
ARG INPUT_REGION
ARG INPUT_BUCKET

RUN apt-get update
RUN apt-get install -y ansible python-pip git curl unzip gettext-base

RUN pip install requests google-auth

RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv
RUN ln -s ~/.tfenv/bin/* /usr/local/bin
RUN tfenv install 0.12.12

WORKDIR /app

COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]