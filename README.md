# privatir-api

VM (VirtualBox) based development environment for the Privatir API.

## Setup

After cloning the repo, get a copy of the `master.key` and add it to
the config directory `config/master.key`. Make sure to do this before
bringing up the VM env.

    git clone git@github.com:Privatir/privatir-api.git
    cd privatir-api/
    cp /path_to_local_copy/master.key config/master.key

## Vagrant

To start the VM do:

    vagrant up privatir-api

To stop the VM (save state) do:

    vagrant suspend privatir-api

To restart a suspended VM (restore saved state) do:

    vagrant resume privatir-api

To access the VM do:

    vagrant ssh privatir-api

To destroy the VM completely do:

    vagrant destroy privatir-api

Happy hacking.
