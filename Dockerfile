###
# Installer stage
###
FROM ubuntu:20.04
LABEL Author="Daniel Duclos-Cavalcanti"
LABEL Email="daniel.duclos-cavalcanti@gmail.com"
LABEL Maintainer="Daniel Duclos-Cavalcanti"

ARG USER_NAME="docker-template"
ARG DEBIAN_FRONTEND=noninteractive

ENV SERVICE jenkins

RUN set -ex
RUN mkdir -p /opt/${SERVICE}

# Base System
RUN apt-get update \
    && apt-get install -y \
    build-essential \
    sudo \
    locales \
    wget curl gnupg \
    gcc-multilib lcov \
    git \
    python3 python3.8-venv python3-pip \
    cmake doxygen \
    tmux vim nano \
    && apt-get clean \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen && update-locale

# Jenkins
RUN wget -qO - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add - \
    && echo "deb http://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list \
    && apt update \
    && apt -y install jenkins \
    && sudo apt-get clean

# Vivado
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt -y --no-install-recommends install \
    libxrender-dev libxtst-dev \
    libtinfo5 libc6-dev:i386 ocl-icd-opencl-dev libjpeg62-dev \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Vivado Installation
# ENV DISPLAY :0
# ENV GEOMETRY 1920x1200

# ARG VIVADO_YEAR="2018"
# ARG VIVADO_VERSION="3"

# RUN mkdir /vivado-installer
# COPY vivado/install_config.txt /vivado-installer/
# COPY vivado/Xilinx_Vivado_${VIVADO_YEAR}.${VIVADO_VERSION}_1106_2127.tar.gz /vivado-installer/

# RUN cat /vivado-installer/Xilinx_Vivado_${VIVADO_YEAR}.${VIVADO_VERSION}_1106_2127.tar.gz | \
#         tar zx --strip-components=1 -C /vivado-installer && \
#         /vivado-installer/xsetup \
#         --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
#         --batch Install \
#         --config /vivado-installer/install_config.txt && \
#         rm -rf /vivado-installer

# Python
RUN pip3 install openpyxl
RUN pip3 install pandas
RUN pip3 install pysqlite3
# RUN pip3 install --upgrade pip

# Environment Variables
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# VOLUME project
COPY project /home/project
WORKDIR /home/project/

COPY scripts/entrypoint.sh /home/entrypoint.sh
RUN chmod +x /home/entrypoint.sh
ENTRYPOINT [ "/home/entrypoint.sh" ]

# Needed for jenkins
EXPOSE 8080
