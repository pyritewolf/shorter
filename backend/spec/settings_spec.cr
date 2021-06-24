require "./spec_helper"
require "../src/main"

describe Shorter do
  it "gets /settings" do
    get "/api/settings"
    JSON.parse(response.body)["shortUrl"].should eq ENV["SHORT_DOMAIN"]
  end
end
