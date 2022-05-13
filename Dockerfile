FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Script unminimizing... that's weird?
RUN sed -i -E -e 's/read.*REPLY/REPLY=y/g' -e 's/apt-get/apt-get -y/g' /usr/local/sbin/unminimize && bash -x /usr/local/sbin/unminimize

RUN apt-get update && \
 apt-get install -y \
   apt-transport-https \
   apt-utils \
   bash \
   curl \
   debian-archive-keyring \
   debian-keyring \
   git \
   netcat \
   openssh-server \
 && \
 curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' > /etc/apt/trusted.gpg.d/caddy-stable.asc && \
 curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' > /etc/apt/sources.list.d/caddy-stable.list && \
 apt-get update && apt-get install caddy && rm -Rf rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
 apt-get install -y \
	imagemagick \
 && \
 rm -Rf rm -rf /var/lib/apt/lists/*

COPY authorized_keys /root/.ssh/authorized_keys

RUN mkdir -p /run/sshd && chmod 0755 /run/sshd && chown root:root /run/sshd

RUN git clone https://github.com/phhusson/netinterpreter /netinterpreter

COPY run.sh /run.sh

RUN mkdir /http

COPY Caddyfile /etc/caddy/Caddyfile
