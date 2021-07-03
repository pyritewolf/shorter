require "uri"

class Shorter::Controller::URL
  private def self.run_url_operation(user : Shorter::User, body, &block)
    begin
      raise HttpError.new(
        FieldError.new("redirect_to", "Redirect value must be a valid URL")
      ) unless URI.parse(body["redirect_to"].to_s).absolute?
      yield
    rescue ex : KeyError
      unless msg = ex.message
        raise HttpError.new(
          FieldError.new("unknown", "Missing URL information, check your form!")
        )
      end
      raise HttpError.new(
        FieldError.new(msg.split(" ")[-1], "This field is required!")
      )
    rescue ex : PQ::PQError
      raise HttpError.new(
        FieldError.new("path", "Path '#{body["path"]}' is already in use")
      ) if ex.fields.any? { |f| f.message == "urls_path_key" }
    end
  end

  def self.handle_post_url(env)
    user = env.request.user
    raise HttpError.new(401) if user.nil?
    self.run_url_operation(user, env.params.json) {
      url = Shorter::URL.new({
        path: env.params.json["path"],
        redirect_to: env.params.json["redirect_to"],
        is_private: env.params.json["is_private"],
        user_id: user.id
      })
      url.save!
      url.to_json
    }
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
    self.run_url_operation(user, env.params.json) {
      url.redirect_to = env.params.json["redirect_to"].to_s
      url.path = env.params.json["path"].to_s
      url.is_private = JSON.parse(env.params.json["is_private"].to_s).as_bool
      url.save!
      url.to_json
    }
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
