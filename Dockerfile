FROM python:3.6

MAINTAINER Daniel Schulz <danielschulz2005@hotmail.com>

ARG KEYFILE="sw/rsa/ssh-key-4k-TESTONLY"
ARG PORT_SSH=2200
ARG THREADS=7
ARG DIRECTORY_LOGS="/apps/sw/data/pshitt/logs"
ARG DIRECTORY_DATA="/apps/sw/data/pshitt/data"

RUN apt-get install -y git && \
    mkdir -p /apps/sw/tmp /apps/sw/data/keyfiles /apps/sw/tools/ssh-honeypot && \
    cd /apps/sw/tools/ssh-honeypot && \
    git clone https://github.com/regit/pshitt.git && \
    pip install --upgrade pip && \
    pip install python-daemon && \
    pip install argparse && \
    pip install paramiko

WORKDIR /apps

COPY ${KEYFILE} /apps/sw/data/keyfiles/keyfile
COPY sw/entrypoint.sh /apps/sw/tools/ssh-honeypot/entrypoint.sh

RUN chmod +x /apps/sw/tools/ssh-honeypot/entrypoint.sh

ENV KEYFILE ${KEYFILE}
ENV PORT_SSH ${PORT_SSH}
ENV THREADS ${THREADS}
ENV DIRECTORY_LOGS ${DIRECTORY_LOGS}
ENV DIRECTORY_DATA ${DIRECTORY_DATA}

EXPOSE ${PORT_SSH}

ENTRYPOINT ["/apps/sw/tools/ssh-honeypot/entrypoint.sh"]
