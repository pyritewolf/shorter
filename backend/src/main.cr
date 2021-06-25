require "oauth2"

require "kemal"
require "clear"

require "./**"


# TODO: Write documentation for `Shorter`
module Shorter
  VERSION = "0.1.0"

  # initialize a pool of database connection:
  db_name = ENV["KEMAL_ENV"] == "test" ? ENV["POSTGRES_TEST_DB"] : ENV["POSTGRES_DB"]
  Clear::SQL.init("postgres://#{ENV["POSTGRES_USER"]}:#{ENV["POSTGRES_PASSWORD"]}@#{ENV["POSTGRES_HOST"]}:#{ENV["POSTGRES_PORT"]}/#{db_name}")
  
  @@oauth2_client : OAuth2::Client? = nil

  def self.oauth2_client
    @@oauth2_client ||= begin
    OAuth2::Client.new(
      "www.googleapis.com",
      ENV["OAUTH_GOOGLE_CLIENT_ID"],
      ENV["OAUTH_GOOGLE_SECRET"],
      authorize_uri: "https://accounts.google.com/o/oauth2/v2/auth",
      token_uri: "https://www.googleapis.com/oauth2/v4/token",
      redirect_uri: "#{ENV["CLIENT_URL"]}#{ENV["OAUTH_GOOGLE_REDIRECT_URL"]}"
    )
    end
  end

  add_handler Shorter::GetAuthHandler.new
  add_handler Shorter::PostAuthHandler.new
  before_all do |env|
    env.response.content_type = "application/json"
  end

  Kemal.run ENV["API_PORT"].to_i
end  
