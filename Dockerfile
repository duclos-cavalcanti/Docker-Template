###
# Installer stage
###
FROM ubuntu:20.04
LABEL Author="Daniel Duclos-Cavalcanti"
LABEL Email="daniel.duclos.cavalcanti@gmail.com"
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

# Python Packages
# RUN pip3 install --upgrade pip
RUN pip3 install openpyxl

# Environment Variables
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# VOLUME project

COPY project /home/project
COPY scripts/entrypoint.sh /home/entrypoint.sh

WORKDIR /home/project/
ENTRYPOINT [ "/home/entrypoint.sh" ]

# Needed for jenkins
EXPOSE 8080
