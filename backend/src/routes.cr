module Shorter
  get "/api/oauth/google" do |env|
    Shorter::Controllers.handle_oauth_login(env)
  end

  get "/api/oauth/callback" do |env|
    Shorter::Controllers.handle_oauth_callback(env)
  end

  post "/api/url" do |env|
    Shorter::Controllers.handle_post_url(env)
  end

  get "/api/url" do |env|
    print env.request.user
    Shorter::Controllers.handle_get_urls
  end

  get "/:path" do |env|
    Shorter::Controllers.handle_redirects(env)
  end
end
