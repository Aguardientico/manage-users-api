class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate
  before_action :should_be_admin

  private

  def authenticate
    if (user = authenticate_with_http_token { |token, _options| User.get_by_token token })
      @current_user = user
    else
      request_http_token_authentication
    end
  end

  def should_be_admin
    @current_user&.is_admin? || head(:forbidden)
  end
end
