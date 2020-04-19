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

# nginx-ingress - Пробрасывает порт 80 и 443 снаружи внутрь контейнера
# https://github.com/helm/charts/tree/master/stable/nginx-ingress

# Для helm v3 надо добавить официальный репозиторий перед установкой для текущего пользователя:
# helm repo add stable https://kubernetes-charts.storage.googleapis.com/
# #helm repo update
# Иначе будут ошибки типа "failed to download "stable/nginx-ingress" (hint: running `helm repo update` may help)"
is_nginx=$(which nginx)
if [ ${#is_nginx} != "0" ]; then
  echo -e "\033[32mНайден Nginx. Производится запуск nginx-ingress на 30к+ портах.\033[0m"
  helm install --namespace kube-system stable/nginx-ingress --name-template movies-nginx-ingress --set controller.service.type=NodePort,controller.service.nodePorts.http=30080,controller.service.nodePorts.https=30443,nodeSelector."kubernetes\.io/role"=master  # Допустимые порты: 30000-32767
else
  echo -e "\033[32mНе найден Nginx. Производится запуск nginx-ingress на стандартных 80 и 443 портах.\033[0m"
  # Для использования 80 и 443 портов сразу, без Nginx на родительской машине:
  helm install --namespace kube-system stable/nginx-ingress --name-template movies-nginx-ingress --set controller.kind=DaemonSet,controller.service.type=ClusterIP,controller.hostNetwork=true
fi
