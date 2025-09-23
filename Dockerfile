# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
ARG BUILD_DATE
ARG VERSION
ARG FREECAD_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=FreeCAD

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/freecad-logo.png && \
  echo "**** install packages ****" && \
  DOWNLOAD_URL=$(curl -sX GET "https://api.github.com/repos/FreeCAD/FreeCAD/releases/latest" \
    | awk -F '(": "|")' '/browser.*Linux-x86_64-py311.AppImage/ {print $3;exit}') && \
  curl -o \
    /tmp/freecad.app -L \
    "${DOWNLOAD_URL}" && \
  cd /tmp && \
  chmod +x freecad.app && \
  ./freecad.app --appimage-extract && \
  mv \
    squashfs-root \
    /opt/freecad && \
  echo "**** launcher ****" && \
  echo \
    "#!/bin/bash" \
    > /usr/bin/freecad && \
  echo \
    "xterm -e /opt/freecad/AppRun \"\${@}\"" \
    >> /usr/bin/freecad && \
  chmod +x /usr/bin/freecad && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
