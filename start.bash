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

echo -en "\033[32mНачинается процедура запуска кластера для  ветки \033[34m$BRANCH\033[0m. Вы согласны продолжить? (Y/N y/n 1/0)[N]:"
varname=0
read varname
if [ $varname ] && ( [ $varname == Y ] || [ $varname == y ] || [ $varname == 1 ] ); then
  echo Продолжаем...
else
  echo Оставнока по Вашему желанию.
  exit 0
fi

mkdir -p $deploy_files
mkdir -p $deploy_files/_secrets
mkdir -p $deploy_files/_databases
mkdir -p $deploy_files/_storages


# Создаем namespace
kubectl create namespace $BRANCH

# Создаем secrets
for secret in $(ls ./_secrets/); do
  cp ./_secrets/$secret $deploy_files/_secrets/$secret
  sed -i -e "s|<<__namespace__>>|${BRANCH}|g" $deploy_files/_secrets/$secret
  sed -i -e "s|<<__code__>>|${BRANCH^^}|g" $deploy_files/_secrets/$secret
done
kubectl apply -f $deploy_files/_secrets

# Создаем storages
for st in $(ls ./_storages/); do
  cp ./_storages/$st $deploy_files/_storages/$st
  sed -i -e "s|<<__namespace__>>|${BRANCH}|g" $deploy_files/_storages/$st
done
kubectl apply -f $deploy_files/_storages

# Создаем databases
for db in $(ls ./_databases/); do
  cp ./_databases/$db $deploy_files/_databases/$db
  sed -i -e "s|<<__namespace__>>|${BRANCH}|g" $deploy_files/_databases/$db
  sed -i -e "s|<<__rabbitmq_image_address__>>|${docker_addr_rabbitmq}|g" $deploy_files/_databases/$db
done
kubectl apply -f $deploy_files/_databases

cp ./static-nginx/deployment-$BRANCH.yaml $deploy_files/static-nginx_deployment-$BRANCH.yaml
sed -i -e "s|<<__static_image_address__>>|${docker_addr_static}|g" $deploy_files/static-nginx_deployment-$BRANCH.yaml

cp ./media-nginx/deployment-$BRANCH.yaml $deploy_files/media-nginx_deployment-$BRANCH.yaml
sed -i -e "s|<<__static_image_address__>>|${docker_addr_static}|g" $deploy_files/media-nginx_deployment-$BRANCH.yaml


kubectl  apply -f $deploy_files/

# Настройка / перезапуск Nginx:
if [ -f $deploy_files/movies_nginx_$BRANCH.conf ]; then
  echo -e "\033[32mФайл $deploy_files/movies-nginx_$BRANCH.conf уже есть и не изменён, т.к. требует настройки только 1 раз.\033[0m"
else
  is_nginx=$(which nginx)
  if [ ${#is_nginx} == "0" ]; then
    echo -e "\033[32mNginx не найден на родительском компьютере.\033[0m"
  else
    cp ./nginx_conf/movies-nginx_$BRANCH.conf $deploy_files/movies-nginx_$BRANCH.conf
    sed -i -e "s|your\.host\.name\.local|${local_addr}|g" $deploy_files/movies-nginx_$BRANCH.conf
    echo -e "\033[32mСоздана конфигурация для ветки $BRANCH сервера Nginx. Может потребоваться перезапустить Nginx командами:\033[0m"
    echo -e "\033[31msudo ln -s $(pwd)/$deploy_files/movies-nginx_$BRANCH.conf /etc/nginx/sites-enabled/movies-nginx_$BRANCH.conf\033[0m"
    echo -e "\033[31msudo service nginx restart\033[0m"
    # Команды ниже надо делать только под пользователем с sudo-правами.
    #sudo ln -s $deploy_files/bonum_nginx_$BRANCH.conf /etc/nginx/sites-enabled/bonum_nginx_$BRANCH.conf
    #sudo service nginx restart
  fi
fi
