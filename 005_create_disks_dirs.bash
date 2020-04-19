#!/usr/bin/env bash

source ".env"

if [[ -f .env.local ]]; then
  source ".env.local"
fi

current_branch=`git rev-parse --abbrev-ref HEAD`

#if [[ ${current_branch} != ${BRANCH} ]]; then
#  echo -e "\033[31mТекущая ветка ${current_branch} не совпадает с версией из файла .env/.env.local (${BRANCH}).\033[0m"
#  echo -e "\033[31mДля продолжения обновления переключитесь в ветку ${BRANCH}\033[0m"
#  exit 1
#fi

if [[ "$BRANCH" == master ]]; then
  BRANCH="prod"
fi

BASE_NODE_DIR=/docker_local_files_${BRANCH}

if [ -z $DIRROOT ]; then
    # Определение каталога, в котором лежит данный (запущенный) скрипт.
    # apt-get install coreutils  # при необходимости, если недоступна команда "readlink"
    # каталог, в котором находится данный файл.
    DIRROOT=$(cd $(dirname $(readlink -e $0)) && pwd)
fi
cd $DIRROOT

mkdir -p $DIRROOT/local_files/movies
mkdir -p $DIRROOT/local_files/media/data
mkdir -p $DIRROOT/local_files/movies/mdb_movies-dev/data
mkdir -p $DIRROOT/local_files/movies/static_movies-dev/data
mkdir -p $DIRROOT/local_files/movies/rabbit_movies-dev/data


if [ -L $BASE_NODE_DIR ]; then
  echo -e "\033[32mСоздана ссылка $BASE_NODE_DIR.\033[0m"
else
  echo -e "\033[31mСсылка $BASE_NODE_DIR ещё не создана.\033[0m"
  echo -e "\033[31mСоздайте выполнив команду ниже\033[0m"
  echo -e "\033[31msudo ln -s $DIRROOT/local_files $BASE_NODE_DIR\033[0m"
fi
