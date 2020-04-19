#!/usr/bin/env bash

source ".env"

if [[ -f .env.local ]]; then
  source ".env.local"
fi

. ./validator.bash_lib

# 0) Валидируем параметры
validate

if [ -z $DIRROOT ]; then
    # Определение каталога, в котором лежит данный (запущенный) скрипт.
    # apt-get install coreutils  # при необходимости, если недоступна команда "readlink"
    # каталог, в котором находится данный файл.
    DIRROOT=$(cd $(dirname $(readlink -e $0)) && pwd)
fi
cd $DIRROOT

bonum_docker_user_id=$(id -u)
if [ bonum_docker_user_id == "0" ]; then
  # Нельзя запускать создание контейнера от рута, т.к. такого пользователя в контейнере не создать
  # и от рута нельзя (крайне нежелательно) запускать программы в контейнере.
  echo -e "\033[31mСоздание контейнера запущено от пользователя root. Это нельзя делать. Завершение работы.\033[0m"
  echo 1
fi

./create_rabbitmq_dockerfile.bash
./create_static_dockerfile.bash

cd $DIRROOT
