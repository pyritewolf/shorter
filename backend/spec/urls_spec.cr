require "./spec_helper"
require "http"

describe Shorter do
  it "fails when getting /api/url with no auth" do
    get "/api/url"
    response.status_code.should eq 302
  end

  it "gets /api/url" do
    url = Shorter::URL.new({
      path: "balrog",
      redirect_to: "gondolin"
    })
    url.save!
    user = Shorter::User.new({
      first_name: "Glorfindel",
      google_id: "houseofthegoldenflower"
    })
    user.save!
    token = Shorter::Controller::OAuth2.get_token_for(user)
    headers = HTTP::Headers.new
    headers.add("Authorization", "Bearer #{token}")
    get("/api/url", headers)
    result = JSON.parse(response.body).as_a
    result.size.should eq 1
    result[0]["path"].should eq url.path
    result[0]["redirect_to"].should eq url.redirect_to
  end

  it "fails when posting /api/url with no auth" do
    post "/api/url"
    response.status_code.should eq 302
  end

  it "posts /api/url" do
    user = Shorter::User.new({
      first_name: "Glorfindel",
      google_id: "houseofthegoldenflower"
    })
    user.save!
    token = Shorter::Controller::OAuth2.get_token_for(user)
    headers = HTTP::Headers.new
    headers.add("Authorization", "Bearer #{token}")
    headers.add("Content-Type", "application/json")
    body = {
      "path" => "ecthelion",
      "redirect_to" => "gondolin"
    }
    post("/api/url", headers, body.to_json)
    response.status_code.should eq 200
    result = Shorter::URL.query.to_a
    result.size.should eq 1
    result[0].path.should eq body["path"]
    result[0].redirect_to.should eq body["redirect_to"]
  end
end
