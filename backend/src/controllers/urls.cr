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

  def self.handle_edit_url(env)
    url_id = env.params.url["url_id"]
    unless url = Shorter::URL.query.find{ id == url_id }
      raise HttpError.new(404, "URL not found")
    end
    user = env.request.user
    return env.redirect ENV["CLIENT_URL"] if user.nil?

    raise HttpError.new(403, "You can't edit that URL") unless url.user_id == user.id
    url.redirect_to = env.params.json["redirect_to"].to_s
    url.path = env.params.json["path"].to_s
    url.save!
  end

  def self.handle_delete_url(env)
    url_id = env.params.url["url_id"]
    unless url = Shorter::URL.query.find{ id == url_id }
      raise HttpError.new(404, "URL not found")
    end
    user = env.request.user
    return env.redirect ENV["CLIENT_URL"] if user.nil?

    raise HttpError.new(403, "You can't delete that URL") unless url.user_id == user.id
    url.delete
  end
end
