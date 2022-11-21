#!/usr/bin/env bash
# exit on error

# tomado de acá:
# https://render.com/docs/deploy-rails

set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate
