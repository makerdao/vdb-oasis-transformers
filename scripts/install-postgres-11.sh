#!/usr/bin/env bash

set -ex

echo "Installing Postgres 11"
sudo service postgresql stop
sudo apt-get remove -q 'postgresql-*'
sudo apt-get update -q
sudo apt-get install -q postgresql-11 postgresql-client-11
sudo cp /etc/postgresql/{9.6,11}/main/pg_hba.conf
sudo service postgresql status
sudo pg_lsclusters
