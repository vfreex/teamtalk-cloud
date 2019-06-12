# based on https://dltech21.github.io/2018/04/13/%E6%90%AD%E5%BB%BATeamTalk%E6%9C%8D%E5%8A%A1%E5%99%A8/
FROM docker.io/centos:7 AS builder

# install dependencies
RUN yum -y install epel-release
RUN yum -y install wget unzip make gcc gcc-c++ protobuf-compiler protobuf-lite-devel \
  log4cxx-devel hiredis-devel mariadb-devel

# download source code
ARG TEAMTALK_DOWNLOAD_URL=https://github.com/vfreex/teamtalk/archive/master.zip
# COPY TeamTalk-master.zip /tmp/TeamTalk-master.zip
RUN wget -O /tmp/teamtalk-master.zip "$TEAMTALK_DOWNLOAD_URL"
RUN unzip /tmp/teamtalk-master.zip -d /root && mv /root/teamtalk-master /root/TeamTalk
WORKDIR /root/TeamTalk/server/src

# protobuf build
RUN pushd ../../pb/ ;\
    sh create.sh ;\
    sh sync.sh ;\
    popd ;\
    # mkdir -p ./base/pb/lib/linux/ ;\
    # cp /usr/lib64/libprotobuf-lite.a ./base/pb/lib/linux/ ;\
    cp -r /usr/include/google ./base/pb/

# build
RUN sh build.sh version 1.0.0

# build the resulting image
FROM docker.io/centos:7
LABEL name="teamtalk-cloud" \
  description="experimental cloud-native TeamTalk distribution" \
  maintainer="Yuxiang Zhu <vfreex@gmail.com>"
RUN yum -y install epel-release
RUN yum install -y less protobuf-lite log4cxx mariadb-libs hiredis
COPY --from=builder /root/TeamTalk/auto_setup/ /root/TeamTalk/auto_setup/
WORKDIR /root/TeamTalk/auto_setup/im_server/
COPY --from=builder /root/TeamTalk/server/im-server-1.0.0.tar.gz .
RUN sh ./setup.sh install && rm -f ./im-server-1.0.0.tar.gz
WORKDIR /root/TeamTalk/auto_setup/im_server/im-server-1.0.0
RUN chmod -R g+wX .
