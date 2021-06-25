class Shorter::Controller::URL
  def self.handle_post_url(env)
    user = env.request.user
    return env.redirect ENV["CLIENT_URL"] if user.nil?
    url = Shorter::URL.new({
      path: env.params.json["path"],
      redirect_to: env.params.json["redirect_to"],
      user_id: user.id
    })
    url.save!
  end

  def self.handle_get_urls()
    Shorter::URL.query.to_a.to_json
  end
end
