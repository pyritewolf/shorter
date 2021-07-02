require "./spec_helper"
require "http"

describe Shorter do
  it "fails when getting /api/url with no auth" do
    get "/api/url"
    response.status_code.should eq 401
  end

  it "gets /api/url" do
    user_1 = Shorter::User.new({
      first_name: "Glorfindel",
      google_id: "houseofthegoldenflower",
    })
    user_1.save!
    user_2 = Shorter::User.new({
      first_name: "Ecthelion",
      google_id: "houseofthesilverfountains",
    })
    user_2.save!
    url_1 = Shorter::URL.new({
      path: "balrog",
      redirect_to: "gondolin",
      user_id: user_1.id,
      is_private: false,
    })
    url_1.save!
    url_2 = Shorter::URL.new({
      path: "maia",
      redirect_to: "aman",
      user_id: user_2.id,
      is_private: true,
    })
    url_2.save!
    token = Shorter::Controller::OAuth2.get_token_for(user_1)
    headers = HTTP::Headers.new
    headers.add("Authorization", "Bearer #{token}")
    get("/api/url", headers)
    result = JSON.parse(response.body).as_a
    result.size.should eq 1
    result[0]["path"].should eq url_1.path
    result[0]["redirect_to"].should eq url_1.redirect_to
    result[0]["user_id"].should eq user_1.id
    result[0]["is_private"].should eq url_1.is_private
  end

  it "fails when posting /api/url with no auth" do
    post "/api/url"
    response.status_code.should eq 401
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
      "redirect_to" => "gondolin",
      "is_private" => false,
    }
    post("/api/url", headers, body.to_json)
    response.status_code.should eq 200
    result = Shorter::URL.query.to_a
    result.size.should eq 1
    result[0].path.should eq body["path"]
    result[0].redirect_to.should eq body["redirect_to"]
    result[0].is_private.should eq body["is_private"]
    result[0].user_id.should eq user.id
  end

  it "fails when deleting /api/url/:url_id with no auth" do
    delete "/api/url/1"
    response.status_code.should eq 401
  end

  it "fails when deleting /api/url/:url_id for non-existing URL" do
    user = Shorter::User.new({
      first_name: "Glorfindel",
      google_id: "houseofthegoldenflower"
    })
    user.save!
    token = Shorter::Controller::OAuth2.get_token_for(user)
    headers = HTTP::Headers.new
    headers.add("Authorization", "Bearer #{token}")
    headers.add("Content-Type", "application/json")
    delete("/api/url/1", headers)
    response.status_code.should eq 404
  end

  it "fails when deleting /api/url/:url_id for unauthed URL" do
    user_1 = Shorter::User.new({
      first_name: "Glorfindel",
      google_id: "houseofthegoldenflower"
    })
    user_1.save!
    user_2 = Shorter::User.new({
      first_name: "Ecthelion",
      google_id: "houseofthesilverfountains"
    })
    user_2.save!
    url = Shorter::URL.new({
      path: "balrog",
      redirect_to: "gondolin",
      user_id: user_2.id,
      is_private: false,
    })
    url.save!
    token = Shorter::Controller::OAuth2.get_token_for(user_1)
    headers = HTTP::Headers.new
    headers.add("Authorization", "Bearer #{token}")
    headers.add("Content-Type", "application/json")
    delete("/api/url/#{url.id}", headers)
    response.status_code.should eq 403
  end

  it "deletes /api/url/:url_id" do
    user = Shorter::User.new({
      first_name: "Glorfindel",
      google_id: "houseofthegoldenflower"
    })
    user.save!
    token = Shorter::Controller::OAuth2.get_token_for(user)
    headers = HTTP::Headers.new
    headers.add("Authorization", "Bearer #{token}")
    headers.add("Content-Type", "application/json")
    url = Shorter::URL.new({
      path: "balrog",
      redirect_to: "gondolin",
      user_id: user.id,
      is_private: false,
    })
    url.save!
    delete("/api/url/#{url.id}", headers)
    response.status_code.should eq 200
    result = Shorter::URL.query.to_a
    result.size.should eq 0
  end

  it "fails when putting /api/url/:url_id with no auth" do
    put "/api/url/1"
    response.status_code.should eq 401
  end

  it "fails when putting /api/url/:url_id for non-existing URL" do
    user = Shorter::User.new({
      first_name: "Glorfindel",
      google_id: "houseofthegoldenflower"
    })
    user.save!
    body = {
      "path" => "ecthelion",
      "redirect_to" => "gondolin",
      "is_private" => false,
    }
    token = Shorter::Controller::OAuth2.get_token_for(user)
    headers = HTTP::Headers.new
    headers.add("Authorization", "Bearer #{token}")
    headers.add("Content-Type", "application/json")
    put("/api/url/1", headers, body.to_json)
    response.status_code.should eq 404
  end

  it "fails when putting /api/url/:url_id for unauthed URL" do
    user_1 = Shorter::User.new({
      first_name: "Glorfindel",
      google_id: "houseofthegoldenflower"
    })
    user_1.save!
    user_2 = Shorter::User.new({
      first_name: "Ecthelion",
      google_id: "houseofthesilverfountains"
    })
    user_2.save!
    url = Shorter::URL.new({
      path: "balrog",
      redirect_to: "gondolin",
      user_id: user_2.id,
      is_private: false,
    })
    url.save!
    body = {
      "path" => "ecthelion",
      "redirect_to" => "gondolin"
    }
    token = Shorter::Controller::OAuth2.get_token_for(user_1)
    headers = HTTP::Headers.new
    headers.add("Authorization", "Bearer #{token}")
    headers.add("Content-Type", "application/json")
    put("/api/url/#{url.id}", headers, body.to_json)
    response.status_code.should eq 403
    url.path.should eq "balrog"
    url.redirect_to.should eq "gondolin"
  end

  it "puts /api/url/:url_id" do
    user = Shorter::User.new({
      first_name: "Glorfindel",
      google_id: "houseofthegoldenflower"
    })
    user.save!
    token = Shorter::Controller::OAuth2.get_token_for(user)
    headers = HTTP::Headers.new
    headers.add("Authorization", "Bearer #{token}")
    headers.add("Content-Type", "application/json")
    url = Shorter::URL.new({
      path: "balrog",
      redirect_to: "gondolin",
      user_id: user.id,
      is_private: false
    })
    url.save!
    body = {
      "path" => "ecthelion",
      "redirect_to" => "silver_fountain",
      "is_private" => true,
    }
    put("/api/url/#{url.id}", headers, body.to_json)
    response.status_code.should eq 200
    result = Shorter::URL.query.find!{ id == url.id}
    result.path.should eq body["path"]
    result.redirect_to.should eq body["redirect_to"]
    result.is_private.should eq body["is_private"]
  end
end
