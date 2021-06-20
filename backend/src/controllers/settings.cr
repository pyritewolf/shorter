class Shorter::Controllers
  def self.handle_get_settings()
    {
      "shortUrl": ENV["SHORT_DOMAIN"],
    }.to_json
  end
end
