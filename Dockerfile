# github-pr-triage
# VERSION 0.1

FROM ubuntu
MAINTAINER Bryan Larsen, bryan@larsen.st
WORKDIR /opt/github-pr-triage
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install python-pip
RUN apt-get -y install git # required for grymt
# we don't use requirements.txt here because the ADD instruction later down makes the Dockerfile non-deterministic from docker's perspective
RUN pip install Flask==0.10.1 Jinja2==2.7.2 MarkupSafe==0.19 Werkzeug==0.9.4 cssmin==0.2.0 grymt==1.0 itsdangerous==0.24 jsmin==2.0.9 python-memcached==1.53 requests==2.2.1 wsgiref==0.1.2

ADD . /opt/github-pr-triage
RUN grymt -w ./app

EXPOSE 5000
ENTRYPOINT MEMCACHE_URL=$MEMCACHED_PORT_11211_TCP_ADDR:$MEMCACHED_PORT_11211_TCP_PORT python app.py
