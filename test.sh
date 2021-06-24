#!/bin/bash
set -e

# Set up local vars
set -a
source .env

KEMAL_ENV="test"

# create database
echo "$COLOR_LIGHT_BLUE 🧑‍🔧 Ensuring DB exists and is up to date... $COLOR_REST"
docker-compose up -d db
docker-compose run -e PGPASSWORD=$POSTGRES_PASSWORD db psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d postgres -c "CREATE DATABASE ${POSTGRES_TEST_DB}"
docker-compose run --rm -e KEMAL_ENV=$KEMAL_ENV api crystal db/micrate.cr up
echo "$COLOR_LIGHT_BLUE ✨ DB ${POSTGRES_TEST_DB} is set up! $COLOR_REST"

# run tests
echo "$COLOR_LIGHT_BLUE 🧑‍🔧 Running tests... $COLOR_REST"
docker-compose run --rm -e KEMAL_ENV=$KEMAL_ENV api crystal spec
echo "$COLOR_LIGHT_BLUE ✨ Tests run! Hope they went well! 🤞 $COLOR_REST"

# drop db
if [ "$GITHUB_ACTIONS" != "true" ]; then
  echo "$COLOR_LIGHT_BLUE 🧑‍🔧 Removing test db... $COLOR_REST"
  docker-compose run -e PGPASSWORD=$POSTGRES_PASSWORD db psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d postgres -c "DROP DATABASE ${POSTGRES_TEST_DB}"
  docker-compose stop
  echo "$COLOR_LIGHT_BLUE ✨ Cleanup done! 🤞 $COLOR_REST"
fi
