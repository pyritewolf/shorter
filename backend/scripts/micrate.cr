#! /usr/bin/env crystal

# require "../src/main"
require "micrate"
require "pg"
require "sqlite3"

Micrate::DB.connection_url = "postgres://#{ENV["POSTGRES_USER"]}:#{ENV["POSTGRES_PASSWORD"]}@#{ENV["POSTGRES_HOST"]}/#{ENV["POSTGRES_DB"]}"
# print Micrate::DB
# Micrate::Cli.run
Micrate.create("add_users", "db/migrations", Time.local)

# Micrate::DB.connect do |db|
#   # print db
#   # Micrate.up(db)
# end

# Micrate::Cli.run_up
