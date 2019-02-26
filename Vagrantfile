# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box = 'xenial-x64'
  config.vm.box_url = 'http://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-vagrant.box'
  config.vm.boot_timeout = 900

  config.vm.define 'privatir-api', primary: true do |api|
    api.vm.hostname = 'privatir-api'
    api.vm.network 'forwarded_port', guest: 22, host: 8022, id: 'ssh'
    api.vm.network 'forwarded_port', guest: 80, host: 8080, id: 'http'
    api.vm.network 'forwarded_port', guest: 443, host: 8443, id: 'https'
    api.vm.provider :virtualbox do |v|
      v.name = 'privatir-api'
      v.customize ['modifyvm', :id, '--uartmode1', 'file', File.join(Dir.pwd, format('%s.log', v.name))]
    end
    api.vm.synced_folder '.', '/opt/privatir-api', automount: true
  end

  config.vm.provision :shell, name: 'dist-upgrade', inline: <<-SHELL
    apt-get update && apt-get -u dist-upgrade -y
  SHELL

  config.vm.provision :shell, name: 'nodejs', inline: <<-SHELL
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    apt-get update && apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev \
      libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev \
      libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn htop tree
    npm install -g json
  SHELL

  config.vm.provision :shell, name: 'postgresql', inline: <<-SHELL
    apt-get install -y postgresql postgresql-contrib libpq-dev
    sudo su - postgres
    sudo -u postgres psql -c "create role privatir with createdb login password 'privatir'";
  SHELL

  config.vm.provision :shell, name: 'redis', inline: <<-SHELL
    apt-get install -y redis-server
    cp /opt/privatir-api/dev/redis/redis.conf /etc/redis/redis.conf
    echo 'requirepass privatir' >> /etc/redis/redis.conf
    systemctl restart redis
  SHELL

  config.vm.provision :shell, name: 'nginx-passenger', inline: <<-SHELL
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
    apt-get install -y apt-transport-https ca-certificates
    sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
    apt-get update && apt-get install -y nginx-extras passenger
    cp /opt/privatir-api/dev/nginx/nginx.conf /etc/nginx/nginx.conf
    cp /opt/privatir-api/dev/nginx/passenger.conf /etc/nginx/passenger.conf
    cp /opt/privatir-api/dev/nginx/sites-enabled/privatir-api /etc/nginx/sites-enabled/privatir-api
    service nginx restart
  SHELL

  config.vm.provision :shell, name: 'rbenv-ruby', privileged: false, inline: <<-SHELL
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    rbenv install 2.5.1
    rbenv global 2.5.1
    rbenv rehash
  SHELL

  config.vm.provision :shell, name: 'rails-setup', privileged: false, inline: <<-SHELL
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    cp /opt/privatir-api/dev/env /opt/privatir-api/.env
    cd /opt/privatir-api && ./bin/setup
  SHELL

  config.vm.provision :shell, name: 'api-status', privileged: false, inline: <<-SHELL
    curl -i http://localhost/status | json
  SHELL

  config.vm.provision :shell, name: 'api-signin', privileged: false, inline: <<-SHELL
    curl -i \
      -H "Content-Type: application/json" \
      -c "cookies.txt" \
      -d '{"email":"user1@email.com","password":"password1"}' \
      -X POST http://localhost/signin | json
  SHELL

  config.vm.provider :virtualbox do |v|
    v.cpus = 2
    v.memory = 2048
  end

  config.vm.synced_folder '.', '/vagrant', disabled: true
end
