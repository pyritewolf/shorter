require "./spec_helper"

describe Shorter do
  it "fails when getting /api/me with no auth" do
    get "/api/me"
    response.status_code.should eq 401
  end

  it "gets my own user info for /api/me" do
    user = Shorter::User.new({
      first_name: "Glorfindel",
      google_id: "houseofthegoldenflower"
    })
    user.save!
    token = Shorter::Controller::OAuth2.get_token_for(user)
    headers = HTTP::Headers.new
    headers.add("Authorization", "Bearer #{token}")
    headers.add("Content-Type", "application/json")
    get("/api/me", headers)
    response.status_code.should eq 200
    result = JSON.parse(response.body)
    result["id"].should eq user.id
    result["first_name"].should eq user.first_name
  end
end
