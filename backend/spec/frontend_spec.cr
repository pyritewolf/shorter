require "./spec_helper"

describe Shorter do
  it "gets /" do
    get "/"
    response.content_type.should eq "text/html"
  end
end
