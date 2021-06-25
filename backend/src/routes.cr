module Shorter
  get "/api/oauth/google" do |env|
    Shorter::Controller::OAuth2.handle_oauth_login(env)
  end
  
  get "/api/oauth/callback" do |env|
    Shorter::Controller::OAuth2.handle_oauth_callback(env)
  end
  
  post "/api/url" do |env|
    Shorter::Controller::URL.handle_post_url(env)
  end
  
  get "/api/url" do |env|
    Shorter::Controller::URL.handle_get_urls()
  end

  get "/api/settings" do |env|
    Shorter::Controller::Settings.handle_get_settings()
  end
  
  get "/" do |env|
    env.response.content_type = "text/html"
    send_file(env, "public/index.html")
  end

  get "/:path" do |env|
    Shorter::Controller::Redirects.handle_redirects(env)
  end
end
