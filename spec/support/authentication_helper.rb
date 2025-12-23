module AuthenticationHelper
  def valid_auth_headers
    { "Authorization" => "Bearer #{ENV['API_TOKEN'] || 'test_token_for_specs'}" }
  end

  def invalid_auth_headers
    { "Authorization" => "Bearer invalid_token" }
  end

  def missing_auth_headers
    {}
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request
  config.include AuthenticationHelper, type: :controller
end
