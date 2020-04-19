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

# nginx-ingress
helm delete  --namespace kube-system bonum-nginx-ingress
