class ApplicationController < ActionController::API
  before_action :authenticate_token

  private

  def authenticate_token
    return true if ENV["SKIP_AUTHENTICATION"] == "true"

    token = request.headers["Authorization"]&.split(" ")&.last

    unless valid_token?(token)
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def valid_token?(token)
    return false if token.blank?

    expected_token = ENV["API_TOKEN"] || (Rails.env.test? ? "test_token_for_specs" : nil)
    token == expected_token
  end
end
