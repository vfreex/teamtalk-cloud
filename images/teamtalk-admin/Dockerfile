FROM docker.io/centos:7 AS builder

# install dependencies
RUN yum -y install wget bsdtar
# download source code
ARG TEAMTALK_DOWNLOAD_URL=https://github.com/vfreex/teamtalk/archive/master.zip
RUN wget -O /tmp/teamtalk.zip -- "$TEAMTALK_DOWNLOAD_URL"
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN mkdir -p /root/src/teamtalk &&\
  bsdtar -xf /tmp/teamtalk.zip --strip-components=1 -C /root/src/teamtalk
WORKDIR /root/src/teamtalk/php


FROM docker.io/centos:7
LABEL name="teamtalk-admin" \
  description="Web admin console for teamtalk-cloud, an experimental cloud-native TeamTalk distribution" \
  maintainer="Yuxiang Zhu <vfreex@gmail.com>"
RUN yum -y install httpd php php-pdo php-mysql
COPY --from=builder /root/src/teamtalk/php /var/www/html
CMD ["httpd", "-DFOREGROUND"]
EXPOSE 80
WORKDIR /var/www/html