# based on https://dltech21.github.io/2018/04/13/%E6%90%AD%E5%BB%BATeamTalk%E6%9C%8D%E5%8A%A1%E5%99%A8/
FROM docker.io/centos:7 AS builder

# install dependencies
RUN yum -y install epel-release && yum clean all
RUN yum -y --setopt=skip_missing_names_on_install=0 install wget bsdtar make gcc gcc-c++ protobuf-compiler \
  protobuf-lite-devel log4cxx-devel hiredis-devel mariadb-devel &&\
  yum clean all

# download source code
ARG TEAMTALK_DOWNLOAD_URL=https://github.com/vfreex/teamtalk/archive/master.zip
RUN wget -O /tmp/teamtalk.zip -- "$TEAMTALK_DOWNLOAD_URL"
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN mkdir -p /root/src/teamtalk &&\
  bsdtar -xf /tmp/teamtalk.zip --strip-components=1 -C /root/src/teamtalk
WORKDIR /root/src/teamtalk/server/src

# protobuf build
RUN pushd ../../pb/ ;\
    sh create.sh ;\
    sh sync.sh ;\
    popd ;\
    ln -s /usr/include/google ./base/pb/

# build TeamTalk
RUN sh build.sh version 1.0.0

# build the resulting image
FROM docker.io/centos:7
LABEL name="teamtalk-cloud" \
  description="experimental cloud-native TeamTalk distribution" \
  maintainer="Yuxiang Zhu <vfreex@gmail.com>"
RUN yum -y install epel-release && yum clean all
RUN yum -y --setopt=skip_missing_names_on_install=0 install less \
  protobuf-lite log4cxx mariadb-libs hiredis &&\
  yum clean all
COPY --from=builder /root/src/teamtalk/auto_setup/ /root/TeamTalk/auto_setup/
WORKDIR /root/TeamTalk/auto_setup/im_server/
COPY --from=builder /root/src/teamtalk/server/im-server-1.0.0.tar.gz .
RUN sh ./setup.sh install && rm -f ./im-server-1.0.0.tar.gz
WORKDIR /root/TeamTalk/auto_setup/im_server/im-server-1.0.0
RUN chmod -R g+wX .
