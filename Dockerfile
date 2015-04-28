FROM debian:testing
MAINTAINER John Gedeon <js1@gedeons.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update &&\
    apt-get -y upgrade &&\
    apt-get -y install ca-certificates nginx-light ruby git golang &&\
    gem install bundler

ENV HOME=/root
ENV GOPATH=/root/gopath
ENV PATH=/root/gopath/bin:$PATH
RUN go get github.com/tools/godep
RUN go get github.com/kelseyhightower/confd
RUN cd /root/gopath/src/github.com/kelseyhightower/confd && ./build && ./install && mkdir -p /etc/confd/{conf.d,templates}
COPY start-up.sh /usr/local/bin/start-up.sh
RUN chmod 755 /usr/local/bin/start-up.sh

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
