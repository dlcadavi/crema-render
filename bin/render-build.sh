#!/usr/bin/env bash
# exit on error

# tomado de acá:
# https://render.com/docs/deploy-rails

set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
