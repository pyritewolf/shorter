require "http/client"
require "jwt"

class Shorter::Controller::OAuth2
  def self.handle_oauth_login(env)
    authorize_uri = Shorter.oauth2_client.get_authorize_uri("https://www.googleapis.com/auth/userinfo.profile") do |params|
      params.add "access_type", "offline"
      params.add "prompt", "consent"
    end
    env.redirect authorize_uri
  end


  def self.handle_oauth_callback(env)
    authorization_code = env.params.query["code"]
    access_token = Shorter.oauth2_client.get_access_token_using_authorization_code(authorization_code)
    client = HTTP::Client.new("www.googleapis.com", tls: true)
    access_token.authenticate(client)
    response = client.get("/oauth2/v1/userinfo?alt=json")
    google_profile = Hash(String, String).from_json(response.body)
    user = Shorter::User.query.find{google_id == google_profile["id"]}
    if user
      user.first_name = google_profile["given_name"] if user.first_name != google_profile["given_name"]
    else
      user = Shorter::User.new({
        first_name: google_profile["given_name"],
        google_id: google_profile["id"],
      })
    end
    user.save!
    jwt_token = Shorter::Controller::OAuth2.get_token_for(user)
    env.redirect "#{ENV["CLIENT_URL"]}?token=#{jwt_token}"
  end

  def self.get_token_for(user : Shorter::User)
    JWT.encode({id: user.id, google_id: user.google_id}, ENV["JWT_KEY"], JWT::Algorithm::HS512)
  end

  def self.get_user_from_token(token : String)
    token_str = token[7, token.size - 7]
    payload, headers = JWT.decode(token_str, ENV["JWT_KEY"], JWT::Algorithm::HS512)
    Shorter::User.query.find{id == payload["id"]}
  end
end
