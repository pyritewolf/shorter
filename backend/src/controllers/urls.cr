class Shorter::Controller::URL
  def self.handle_post_url(env)
    url = Shorter::URL.new({
      path: env.params.json["path"],
      redirect_to: env.params.json["redirect_to"],
    })
    url.save!
  end

  def self.handle_get_urls()
    Shorter::URL.query.to_a.to_json
  end
end
