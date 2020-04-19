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
echo -e "    \033[32m< Сборка контейнера \033[4static\033[0m \033[34m\033[32m>\033[0m"
docker build -f ./static-nginx/Dockerfile-base -t ${docker_addr_static}:latest ./static-nginx
docker push ${docker_addr_static}:latest
cd $DIRROOT
