class Shorter::Controller::Redirects
  def self.handle_redirects(env)
    url = Shorter::URL.query.find!{path == env.params.url["path"]}
    env.redirect url.redirect_to
  end
end
