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
    Shorter::Controllers.handle_get_urls()
  end
  
  get "/" do |env|
    env.response.content_type = "text/html"
    send_file(env, "public/index.html")
  end

  get "/:path" do |env|
    Shorter::Controllers.handle_redirects(env)
  end
end
