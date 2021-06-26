class Shorter::Controller::User
  def self.handle_get_me(env)
    user = env.request.user
    return env.redirect ENV["CLIENT_URL"] if user.nil?
    user.to_json
  end
end
