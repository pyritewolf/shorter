require "./spec_helper"

describe Shorter do
  it "gets /api/settings" do
    get "/api/settings"
    JSON.parse(response.body)["shortUrl"].should eq ENV["SHORT_DOMAIN"]
  end
end
