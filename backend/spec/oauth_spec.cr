require "./spec_helper"
require "http"

describe Shorter do
  it "redirects you to google when getting /api/oauth/google" do
    get "/api/url"
    response.status_code.should eq 401
  end
end
