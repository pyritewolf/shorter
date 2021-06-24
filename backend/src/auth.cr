require "jwt"

class HTTP::Request
  property user : Shorter::User? = nil

  def user(usr)
    @user = usr
  end
end

class UnauthorizedException < Exception
end

class Shorter::AuthHandler < Kemal::Handler
  only ["/api/url"]

  def call(env)
    # continue on to next handler unless the request matches the only filter
    return call_next(env) unless only_match?(env)
    
    return env.redirect ENV["CLIENT_URL"] unless env.request.headers["Authorization"]?
    unless value = env.request.headers["Authorization"]
      return  env.redirect ENV["CLIENT_URL"]
    end
    if value.size > 0 && value.starts_with?("Bearer")
      token_str = value[7, value.size - 7]
      payload, headers = JWT.decode(token_str, ENV["JWT_KEY"], JWT::Algorithm::HS512)
      unless user = Shorter::User.query.find{id == payload["id"]}
        env.redirect ENV["CLIENT_URL"]
      end
      env.request.user = user
      env.response.content_type = "application/json"
      call_next(env)
    else 
      env.redirect ENV["CLIENT_URL"]
    end
  end
end
