# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:alpine322

# set version label
ARG BUILD_DATE
ARG VERSION
ARG KEEPASSXC_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=KeePassXC

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/keepassxc-logo.png && \
  echo "**** install packages ****" && \
  if [ -z ${KEEPASSXC_VERSION+x} ]; then \
    KEEPASSXC_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.22/community/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
    && awk '/^P:keepassxc$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
  fi && \
  apk add --no-cache \
    keepassxc==${KEEPASSXC_VERSION} && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3001

VOLUME /config
