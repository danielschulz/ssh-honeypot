FROM python:3.6

MAINTAINER Daniel Schulz <danielschulz2005@hotmail.com>

ARG PORT_SSH=2200
ARG THREADS=7
ARG KEYFILE="sw/rsa/ssh-key-4k-TESTONLY"
ARG DIRECTORY_LOGS="/apps/data/pshitt/logs"
ARG DIRECTORY_DATA="/apps/data/pshitt/data"
ARG INTERNET_JQ_URL="https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64"
ARG INTERNET_PYTHON_DAEMON_URL="https://pypi.python.org/packages/f4/59/816004688f8e8602526553cd96226f34657ce4a86daa2240c3eebb0568a3/python_daemon-2.1.2-py2.py3-none-any.whl#md5=d7d38fa204e3e2a82a3afa0b8e4cc621"

RUN apt-get install -y git && \
    mkdir -p /apps/sw/tmp /apps/data/keyfiles /apps/sw/tools/ssh-honeypot && \
    cd /apps/sw/tools/ssh-honeypot && \
    git clone https://github.com/regit/pshitt.git && \
    pip install --upgrade pip && \
    pip install ${INTERNET_PYTHON_DAEMON_URL} && \
    pip install argparse && \
    pip install paramiko && \
    wget "${INTERNET_JQ_URL}" -O /apps/sw/tools/jq

WORKDIR /apps

COPY ${KEYFILE} /apps/data/keyfiles/keyfile
COPY sw/entrypoint.sh /apps/sw/tools/ssh-honeypot/entrypoint.sh

RUN chmod +x /apps/sw/tools/jq /apps/sw/tools/ssh-honeypot/entrypoint.sh

ENV PATH /apps/sw/tools/:${PATH}
ENV PORT_SSH ${PORT_SSH}
ENV THREADS ${THREADS}
ENV KEYFILE ${KEYFILE}
ENV DIRECTORY_LOGS ${DIRECTORY_LOGS}
ENV DIRECTORY_DATA ${DIRECTORY_DATA}

EXPOSE ${PORT_SSH}

ENTRYPOINT ["/apps/sw/tools/ssh-honeypot/entrypoint.sh"]
