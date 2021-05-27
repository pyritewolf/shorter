require "http/client"

class Shorter::Controllers
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
      if user.first_name != google_profile["given_name"]
        user.first_name = google_profile["given_name"]
        user.save!
      end
    else
      user = Shorter::User.new({
        first_name: google_profile["given_name"],
        google_id: google_profile["id"],
      })
      user.save!
    end
    jwt_token = JWT.encode({id: user.id, google_id: user.google_id}, ENV["JWT_KEY"], JWT::Algorithm::HS512)
    env.redirect "#{ENV["CLIENT_URL"]}?token=#{jwt_token}"
  end
end
