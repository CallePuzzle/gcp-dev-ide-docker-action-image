FROM debian:10-slim

RUN apt-get update
RUN apt-get install -y python-virtualenv git curl unzip gettext-base gnupg2

RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-buster main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install google-cloud-sdk -y

RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv
RUN ln -s ~/.tfenv/bin/* /usr/local/bin
RUN tfenv install 0.12.12

RUN mkdir /app
RUN virtualenv -p python3 /app/venv
RUN /app/venv/bin/pip install ansible requests google-auth

COPY src/ /app/
COPY entrypoint.sh /app/entrypoint.sh

WORKDIR /github/workspace

ENTRYPOINT ["/app/entrypoint.sh"]