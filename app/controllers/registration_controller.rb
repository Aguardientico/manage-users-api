class RegistrationController < ApplicationController
  skip_before_action :authenticate
  skip_before_action :should_be_admin

  def create
    user = User.create(email: params[:email], password: params[:password], is_registering: true)
    if user.persisted?
      response.headers['Token'] = user.jwt_token
      render json: user, status: :ok
    else
      render json: {
        errors: user.errors.full_messages
      }, status: :bad_request
    end
  end
end
