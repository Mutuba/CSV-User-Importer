#!/bin/bash

echo "Running Release Tasks"
echo "Running Migrations"
bundle exec rails db:migrate


echo "Clearing Rails Cache"
bundle exec rails r "Rails.cache.clear"

echo "Removing temp file"
rm -f tmp/pids/server.pid
echo "Done running release.sh"

exec "$@"
