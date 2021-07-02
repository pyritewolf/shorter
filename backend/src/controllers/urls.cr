class Shorter::Controller::URL
  def self.handle_post_url(env)
    user = env.request.user
    raise HttpError.new(401) if user.nil?
    begin
      url = Shorter::URL.new({
        path: env.params.json["path"],
        redirect_to: env.params.json["redirect_to"],
        is_private: env.params.json["is_private"],
        user_id: user.id
      })
    rescue ex : KeyError
      unless msg = ex.message
        raise HttpError.new(422, "Missing URL information, check your form!")
      end
      raise HttpError.new(422, "Missing URL information: #{msg.split(" ")[-1]}")
    end
    url.save!
  end

  def self.handle_get_urls(env)
    user = env.request.user
    raise HttpError.new(401) if user.nil?
    Shorter::URL.query.to_a.select{ |url|
      !url.is_private || url.user_id == user.id
    }.to_json
  end

  def self.handle_edit_url(env)
    url_id = env.params.url["url_id"]
    unless url = Shorter::URL.query.find{ id == url_id }
      raise HttpError.new(404, "URL not found")
    end
    user = env.request.user
    raise HttpError.new(401) if user.nil?

    raise HttpError.new(403, "You can't edit that URL") unless url.user_id == user.id
    begin
      url.redirect_to = env.params.json["redirect_to"].to_s
      url.path = env.params.json["path"].to_s
      url.is_private = JSON.parse(env.params.json["is_private"].to_s).as_bool
    rescue ex : KeyError
      unless msg = ex.message
        raise HttpError.new(422, "Missing URL information, check your form!")
      end
      raise HttpError.new(422, "Missing URL information: #{msg.split(" ")[-1]}")
    end
    url.save!
  end

  def self.handle_delete_url(env)
    url_id = env.params.url["url_id"]
    unless url = Shorter::URL.query.find{ id == url_id }
      raise HttpError.new(404, "URL not found")
    end
    user = env.request.user
    raise HttpError.new(401) if user.nil?

    raise HttpError.new(403, "You can't delete that URL") unless url.user_id == user.id
    url.delete
  end
end
