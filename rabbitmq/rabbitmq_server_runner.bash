#!/usr/bin/env bash

# ловим SIGINT или SIGTERM и выходим
trap "kill -TERM \$(ps aux | grep 'rabbitmq-server' | grep -v grep | awk '{print \$2}')" SIGINT SIGTERM

movies_vhost=$(rabbitmqctl list_vhosts | grep movies)
if [ "${movies_vhost}=" == "movies=" ]; then
  echo -e "    \033[32m>Производится запуск RabbitMQ<\033[0m"
  docker-entrypoint.sh rabbitmq-server rabbitmq-server &
else
  echo -e "    \033[32m>Производится инициализация и запуск RabbitMQ<\033[0m"
  docker-entrypoint.sh rabbitmq-server rabbitmq-server &

  tmp_wait_rabbit_start=1
  while [ $tmp_wait_rabbit_start -ne 0 ]; do
    echo -e '    \033[32m><Ожидание запуска RabbitMQ, чтобы создать vhost><\033[0m'
    rabbitmqctl status >/dev/null
    tmp_wait_rabbit_start=$?
    sleep 1
  done

  rabbitmqctl add_user $RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASS
  rabbitmqctl add_vhost movies
  rabbitmqctl set_permissions -p movies $RABBITMQ_DEFAULT_USER ".*" ".*" ".*"
fi
sleep infinity
