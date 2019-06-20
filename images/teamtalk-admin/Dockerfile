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
RUN chown apache:root -R /var/www/html && chmod -R u=rwX,g=rX,o= /var/www/html
COPY run-httpd.sh /usr/local/bin/run-httpd.sh
RUN chmod +x /usr/local/bin/run-httpd.sh \
  && sed -i 's/^Listen\s.*$/Listen 8080/g' /etc/httpd/conf/httpd.conf \
  && sed -i 's#^LogLevel\s.*$#LogLevel info#g' /etc/httpd/conf/httpd.conf \
  && sed -i 's#^ErrorLog\s.*$#ErrorLog "/proc/self/fd/2"#g' /etc/httpd/conf/httpd.conf \
  && sed -i 's#^\s*CustomLog\s.*$#CustomLog "/proc/self/fd/1" combined#g' /etc/httpd/conf/httpd.conf \
  && chgrp -R root /run/httpd /var/lib/php/session && chmod -R g+rwX /run/httpd /var/lib/php/session
CMD ["/usr/local/bin/run-httpd.sh"]
EXPOSE 8080
WORKDIR /var/www/html
