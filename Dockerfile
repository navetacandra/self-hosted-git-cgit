FROM debian:13-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
	openssh-server \
        cgit \
        nginx \
        spawn-fcgi \
        fcgiwrap \
        git \
        curl \
        fcgiwrap && \
    apt-get clean

RUN useradd -m -s /usr/bin/git-shell git && \
    mkdir -p /home/git/.ssh && \
    touch /home/git/.ssh/authorized_keys && \
    chown -R git:www-data /home/git && \
    chmod 750 /home/git

COPY cgit/cgit.css /usr/share/cgit/cgit.css
COPY cgit/cgitrc /etc/cgitrc
COPY cgit/server.conf /etc/nginx/sites-available/default
COPY bin/entrypoint.sh /entrypoint.sh
COPY bin/new-git /usr/bin/new-git

RUN mkdir -p /run && chown www-data:www-data /run
RUN mkdir -p /var/run/sshd

EXPOSE 80 22
ENTRYPOINT ["./entrypoint.sh"]
