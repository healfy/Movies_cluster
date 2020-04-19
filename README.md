# Movies_cluster

This is test project and now work only on one config
>BRANCH=dev
>deploy_files=./local_files/deploy_files
>local_addr=192.168.34.2 # local address

###In the first you must create .env.local file with all this options,change only local_addr!!!!

## Requirement Technological Stack:
 * ####  kubelet=1.15.4-00 kubeadm=1.15.4-00 kubectl=1.15.4-00
 * ####  Docker
 * ####  Helm

### Installing K8s v 1.15.4-00
 * ``sudo apt-get update ``
 * ``sudo apt-get install -y apt-transport-https curl``
 * ``sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - ``
 * ``echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list``
 * ``sudo apt-get update``
 * ``sudo apt-get install -y kubelet=1.15.4-00 kubeadm=1.15.4-00 kubectl=1.15.4-00``
 * ``sudo apt-mark hold kubelet kubeadm kubectl  # hold version``
 * init cluster

### Installing Helm
 * ``sudo snap install helm --classic``
 > Add to .bashrc ``export PATH=$PATH:/snap/bin``
 * ``source .bashrc``

## Start
 * ``./005_create_disks_dirs.bash``
   > In command line log you will see necessary command, that create's link to ./local_files
     ##### `sudo ln -s /home/dev/Movies_cluster/local_files /docker_local_files_dev`

 * ``./start.bash``
   > In command line log you will see necessary command, that create's link to nginx conf file
   ###### ``sudo ln -s /home/dev/Movies_cluster/./local_files/deploy_files/movies_nginx_dev.conf /etc/nginx/sites-enabled/movies_nginx_dev.conf ``
   ###### ``sudo service nginx restart``
 * ``./start_consul_ingress.bash``

## Stop
 * ``./stop.bash``
 * ``./stop_consul_ingress.bash``
