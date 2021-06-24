require "spec"
require "spec-kemal"

require "../src/main"

def get_test_db_url()
  "postgres://#{ENV["POSTGRES_USER"]}:#{ENV["POSTGRES_PASSWORD"]}@#{ENV["POSTGRES_HOST"]}:#{ENV["POSTGRES_PORT"]}/#{ENV["POSTGRES_TEST_DB"]}"
end

def cleanup_test_db()
  # Clear::SQL.init("postgres://#{ENV["POSTGRES_USER"]}:#{ENV["POSTGRES_PASSWORD"]}@#{ENV["POSTGRES_HOST"]}:#{ENV["POSTGRES_PORT"]}/#{db_name}")
  Shorter::User.query.to_delete.execute
  Shorter::URL.query.to_delete.execute
end

Spec.before_each { 
  cleanup_test_db()
}
