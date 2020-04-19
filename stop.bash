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

echo -en "\033[32mНачинается процедура остановки кластера для  ветки \033[34m$BRANCH\033[0m. Вы согласны продолжить? (Y/N y/n 1/0)[N]:"
varname=0
read varname
if [ $varname ] && ( [ $varname == Y ] || [ $varname == y ] || [ $varname == 1 ] ); then
  echo Продолжаем...
else
  echo Оставнока по Вашему желанию.
  exit 0
fi


kubectl delete -f $deploy_files/_databases
kubectl delete -f $deploy_files/_storages
kubectl delete -f $deploy_files/_secrets
kubectl delete namespace $BRANCH

