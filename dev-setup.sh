#!/bin/bash
set -e

# Set up local vars
set -a
source .env

# Set up colors
COLOR_REST="$(tput sgr0)"
COLOR_GREEN="$(tput setaf 2)"
COLOR_MAGENTA="$(tput setaf 5)"
COLOR_LIGHT_BLUE="$(tput setaf 81)"

# create database
echo "$COLOR_LIGHT_BLUE 🧑‍🔧 Ensuring DB exists... $COLOR_REST"
docker-compose up -d db
docker-compose exec -e PGPASSWORD=$POSTGRES_PASSWORD db psql -h db -U $POSTGRES_USER -d postgres -c "SELECT 'CREATE DATABASE ${POSTGRES_DB}' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${POSTGRES_DB}')"
echo "$COLOR_LIGHT_BLUE ✨ DB ${POSTGRES_DB} is set up! $COLOR_REST"

# install dependencies
echo "$COLOR_LIGHT_BLUE 🧑‍🔧 Installing backend dependencies... $COLOR_REST"
docker-compose run --rm api shards install
echo "$COLOR_LIGHT_BLUE ✨ Backend dependencies ready! $COLOR_REST"

echo "$COLOR_LIGHT_BLUE 🧑‍🔧 Installing frontend dependencies... $COLOR_REST"
docker-compose run --rm ui npm install
echo "$COLOR_LIGHT_BLUE ✨ Frontend dependencies ready! $COLOR_REST"

# Done!
docker-compose stop
echo
echo "$COLOR_GREEN Shorter setup ready! 🎉 $COLOR_REST"
echo "$COLOR_MAGENTA  Remember to manually run the SQL$COLOR_REST found in /backend/db/migrations before doing a docker-compose up"
