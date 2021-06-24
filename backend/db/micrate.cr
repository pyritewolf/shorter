require "micrate"

db_name = ENV["KEMAL_ENV"] == "test" ? ENV["POSTGRES_TEST_DB"] : ENV["POSTGRES_DB"]
Micrate::DB.connection_url = "postgres://#{ENV["POSTGRES_USER"]}:#{ENV["POSTGRES_PASSWORD"]}@#{ENV["POSTGRES_HOST"]}:#{ENV["POSTGRES_PORT"]}/#{db_name}"
Micrate::Cli.run
