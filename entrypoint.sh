#!/bin/bash
# set -eu

yarn

bundle install

# rake db:migrate

# if [ -e /products/tmp/pids/*.pid ]; then rm /products/tmp/pids/*.pid; fi
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

exec "$@"
