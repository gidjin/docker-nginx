FROM debian:jessie
MAINTAINER John Gedeon <js1@gedeons.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update &&\
    apt-get -y upgrade &&\
    apt-get -y install ca-certificates nginx-light ruby git golang wget &&\
    gem install bundler

USER root
ENV HOME=/root
WORKDIR /root
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.9.0/confd-0.9.0-linux-amd64
RUN mv confd-0.9.0-linux-amd64 /usr/local/bin/confd && chmod 755 /usr/local/bin/confd
RUN gem install daemons faraday
RUN mkdir -p /etc/confd/{conf.d,templates}
COPY bin/* /usr/local/bin/
RUN chmod 755 /usr/local/bin/*
COPY lib/* /root/

RUN apt-get clean &&\
    rm -rf /tmp/* /var/tmp/* &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN ln -sf /dev/stdout /var/log/confd.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

CMD ["start-up.sh"]
