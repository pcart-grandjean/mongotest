#!/usr/bin/env bash

if [ ! $# -eq 2 ]
then
  echo "Provide two arguments: first the login then the password to hash."
  exit 1
fi

login=$1
password=$2

echo -n "${login}:mongo:${password}" | md5sum | awk '{print $1}'
