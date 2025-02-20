FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

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
  /usr/share/icons/hicolor/48x48/apps/freecad.png \
  https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/freecad-logo.png
RUN \
echo "**** install packages ****" && \
apt-get update && \
apt-get upgrade -y && \
apt-get install -y --no-install-recommends \
  gstreamer1.0-alsa \
  gstreamer1.0-gl \
  gstreamer1.0-gtk3 \
  gstreamer1.0-libav \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-pulseaudio \
  gstreamer1.0-qt5 \
  gstreamer1.0-tools \
  gstreamer1.0-x \
  libgstreamer1.0 \
  libgstreamer-plugins-bad1.0 \
  libgstreamer-plugins-base1.0 \
  libwebkit2gtk-4.0-37 \
  libwx-perl
RUN \
  echo " install freecad from appimage " && \
  freecad_version="1.0.0" && \
  cd /tmp && \
  curl -o /tmp/freecad.app -L https://github.com/FreeCAD/FreeCAD/releases/download/1.0.0/FreeCAD_1.0.0-conda-Linux-x86_64-py311.AppImage && \
  chmod +x /tmp/freecad.app && \
  ./freecad.app --appimage-extract && \
  mv squashfs-root /opt/freecad && \
  ln -s /opt/freecad/AppRun /usr/bin/freecad &&  \
  sed -i 's|</applications>|  <application title="FreeCAD*" type="normal">\n    <maximized>yes</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml && \
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
