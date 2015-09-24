#!/usr/bin/env bash

if [ ! $# -eq 1 ]
then
  echo "Please one argument: the key of the value you are looking for."
  exit 1
fi

key=$1

# hiera --config hiera.yaml --json facter.json --debug ${key}
# hiera --config hiera.yaml --json facts.json --debug ${key}
hiera --config hiera.yaml --debug ${key} hostname=cubitus
