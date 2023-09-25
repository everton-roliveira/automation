#!/bin/bash
set -o nounset

# Carrega as variaveis de ambiente do arquivo .env localizado na raiz do projeto
source /.env
JENKINS_CONTAINER_NAME=$JENKINS_CONTAINER_NAME
JENKINS_AGENT_SSH_PUBKEY=$JENKINS_AGENT_SSH_PUBKEY

# Subo o container passando as variaveis necessárias, lembrando que o o comando sobre o docker compose no nivel dessa pasta
CONTAINER_NAME=$JENKINS_CONTAINER_NAME JENKINS_AGENT_SSH_PUBKEY=$JENKINS_AGENT_SSH_PUBKEY docker compose up --build -d

sleep 10

# Ferramentas necessárias
docker exec $JENKINS_CONTAINER_NAME bash -c "
    apt-get update && apt-get install -y \
    curl \
    bash \
    git-lfs \
    less \
    locales \
    netcat-openbsd \
    openssh-server \
    patch \
    && apt-get clean"

# Instala o nodejs e o npm
docker exec $JENKINS_CONTAINER_NAME bash -c "curl -sL https://deb.nodesource.com/setup_16.x | -E bash -"
docker exec $JENKINS_CONTAINER_NAME bash -c "apt-get install -y nodejs \
    npm"

# Instala o lerna global
docker exec $JENKINS_CONTAINER_NAME bash -c "npm install -g lerna"