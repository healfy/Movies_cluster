FROM rabbitmq:3.7.19

RUN apt-get clean; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get -y install locales net-tools iputils-ping iproute2 htop mc wget curl nano; \
    sed -i 's/# ru_RU\.UTF-8 UTF-8/ru_RU\.UTF-8 UTF-8/' /etc/locale.gen; \
    locale-gen ru_RU.UTF-8; \
    rm -rf /tmp/*; \
    apt-get clean; \
    rm -rf /var/log/*
ENV LANG ru_RU.UTF-8

COPY ./rabbitmq_server_runner.bash /
#CMD ["/bin/sleep", "infinity"]
CMD ["/rabbitmq_server_runner.bash"]
