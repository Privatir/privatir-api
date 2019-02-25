# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "xenial-x64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-vagrant.box"
  config.vm.boot_timeout = 900

  config.vm.synced_folder ".", "/opt/privatir-api", automount: true
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 443, host: 8443

  config.vm.provider :virtualbox do |v|
    v.name = "privatir-api"
    v.cpus = 1
    v.memory = 1024*2
  end

  config.vm.provision "shell", name: "upgrade", inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get -u dist-upgrade -y
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    apt-get update
    apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev \
      libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev \
      libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn
  SHELL

  config.vm.provision "shell", name: "rbenv", privileged: false, inline: <<-SHELL
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    rbenv install 2.6.1
    rbenv global 2.6.1
    ruby -v
    gem install bundler
    rbenv rehash
  SHELL

  config.vm.provision "shell", name: "nginx", inline: <<-SHELL
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
    apt-get install -y apt-transport-https ca-certificates
    # Add Passenger APT repository
    sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
    apt-get update
    # Install Passenger & Nginx
    apt-get install -y nginx-extras passenger
    # Move config files into place
    cp /opt/privatir-api/dev/nginx/nginx.conf /etc/nginx/nginx.conf
    cp /opt/privatir-api/dev/nginx/passenger.conf /etc/nginx/passenger.conf
    service nginx restart
  SHELL

  config.vm.provision "shell", name: "postgres", inline: <<-SHELL
    apt-get install -y postgresql postgresql-contrib libpq-dev
    sudo su - postgres
    sudo -u postgres createuser privatir
    sudo -u postgres createdb -O privatir privatir_development
    exit
  SHELL

  config.vm.provision "shell", name: "nginx-virtual-server", inline: <<-SHELL
    cp /opt/privatir-api/dev/nginx/sites-enabled/privatir-api /etc/nginx/sites-enabled/privatir-api
    service nginx restart
  SHELL

  # config.vm.provision "shell", name: "", inline: <<-SHELL
  # SHELL
end
