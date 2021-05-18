FROM ghcr.io/linuxserver/baseimage-rdesktop-web:focal

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
    firefox \
    mate-applets \
    mate-applet-brisk-menu \
    mate-terminal \
    sudo \
    pluma \
    ubuntu-mate-artwork \
    ubuntu-mate-default-settings \
    ubuntu-mate-desktop \
    ubuntu-mate-icon-themes && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*


RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN echo 'deb http://dl.google.com/linux/chrome/deb/ stable main'     > /etc/apt/sources.list.d/google-chrome.list

RUN DEBIAN_FRONTEND=noninteractive \
  sudo apt-get update

  

RUN sudo DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends google-chrome-stable


RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg

RUN sudo DEBIAN_FRONTEND=noninteractive \
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
RUN sudo DEBIAN_FRONTEND=noninteractive \
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
RUN sudo DEBIAN_FRONTEND=noninteractive \
    rm -f packages.microsoft.gpg

RUN sudo DEBIAN_FRONTEND=noninteractive \
    sudo apt install apt-transport-https
RUN sudo DEBIAN_FRONTEND=noninteractive \
    sudo apt update
RUN sudo DEBIAN_FRONTEND=noninteractive \
  sudo apt -y install code


RUN DEBIAN_FRONTEND=noninteractive \
    apt install -y vim nano traceroute nmap iperf3 iperf  net-tools python3-pip python-pip vim wget curl htop git axel aria2 apt-transport-https ca-certificates curl software-properties-common gnupg2 pigz ifupdown2 bwm-ng iotop lsscsi lshw unzip p7zip sudo screen tree  git tinc mtr tcpdump nmap asciinema bash bash-completion  ca-certificates tzdata sudo dpkg apt-transport-https openssh-client binutils dnsutils bridge-utils util-linux inetutils-traceroute net-tools curl wget grep sed rsync socat netcat htop nano vim-tiny tar gzip bzip2 xz-utils zip unzip python3 python3-dev git git-flow && wget -q -O - https://bootstrap.pypa.io/get-pip.py | python3 - && pip3 install --no-cache-dir --upgrade pip setuptools wheel && pip3 install --no-cache-dir virtualenv pipreqs pylint speedtest-cli

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    chromium-chromedriver \
  # Start chromium-browser via wrapper script with --no-sandbox argument:
  && mv /usr/lib/chromium-browser/chromium-browser /usr/lib/chromium-browser/chromium-browser-original \
  && printf '%s\n' '#!/bin/sh' \
    'exec /usr/lib/chromium-browser/chromium-browser-original --no-sandbox "$@"' \
    > /usr/lib/chromium-browser/chromium-browser && chmod +x /usr/lib/chromium-browser/chromium-browser \
  # Remove obsolete files:
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /usr/share/doc/* \
    /var/cache/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config
