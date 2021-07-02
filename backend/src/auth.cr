class HTTP::Request
  property user : Shorter::User? = nil

  def user(usr)
    @user = usr
  end
end

class UnauthorizedException < Exception
end

def validate_auth(env)
  return false unless env.request.headers["Authorization"]?
  unless value = env.request.headers["Authorization"]
    return false
  end
  return false unless value.size > 0 && value.starts_with?("Bearer")
  user = Shorter::Controller::OAuth2.get_user_from_token(value)
  return false unless user.not_nil!
  env.request.user = user
  env.response.content_type = "application/json"
  return true
end

class Shorter::GetAuthHandler < Kemal::Handler
  only ["/api/url", "/api/me"]

  def call(env)
    # continue on to next handler unless the request matches the only filter
    return call_next(env) unless only_match?(env)
    return call_next(env) if validate_auth(env) 
    raise Shorter::HttpError.new(401)
  end
end

class Shorter::PostAuthHandler < Kemal::Handler
  only ["/api/url"], "POST"

  def call(env)
    # continue on to next handler unless the request matches the only filter
    return call_next(env) unless only_match?(env)
    return call_next(env) if validate_auth(env)
    raise Shorter::HttpError.new(401)
  end
end

class Shorter::PutAuthHandler < Kemal::Handler
  only ["/api/url/:url_id"], "PUT"

  def call(env)
    # continue on to next handler unless the request matches the only filter
    return call_next(env) unless only_match?(env)
    return call_next(env) if validate_auth(env)
    raise Shorter::HttpError.new(401)
  end
end

class Shorter::DeleteAuthHandler < Kemal::Handler
  only ["/api/url/:url_id"], "DELETE"

  def call(env)
    # continue on to next handler unless the request matches the only filter
    return call_next(env) unless only_match?(env)
    return call_next(env) if validate_auth(env)
    raise Shorter::HttpError.new(401)
  end
end
