#!/usr/bin/env bash
source ".env"

if [[ -f .env.local ]]; then
  source ".env.local"
fi

if [ -z $DIRROOT ]; then
    # Определение каталога, в котором лежит данный (запущенный) скрипт.
    # apt-get install coreutils  # при необходимости, если недоступна команда "readlink"
    # каталог, в котором находится данный файл.
    DIRROOT=$(cd $(dirname $(readlink -e $0)) && pwd)
fi

cd $DIRROOT
echo -e "    \033[32m< Сборка контейнера \033[4rabbitmq\033[0m \033[34m\033[32m>\033[0m"
docker build -f ./rabbitmq/rabbitmq_server.Dockerfile -t ${docker_addr_rabbitmq}:latest ./rabbitmq/
docker push ${docker_addr_rabbitmq}:latest
cd $DIRROOT
