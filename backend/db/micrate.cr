require "micrate"

Micrate::DB.connection_url = "postgres://#{ENV["POSTGRES_USER"]}:#{ENV["POSTGRES_PASSWORD"]}@#{ENV["POSTGRES_HOST"]}:#{ENV["POSTGRES_PORT"]}/#{ENV["POSTGRES_DB"]}"
print Micrate::DB
Micrate::Cli.run
