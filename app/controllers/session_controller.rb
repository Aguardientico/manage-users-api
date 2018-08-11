class SessionController < ApplicationController
  skip_before_action :authenticate
  skip_before_action :should_be_admin

  def create
    user = User.login(email: params[:email], password: params[:password])
    if user
      render json: {
        message: "success", token: user.jwt_token
      }, status: :ok
    else
      render json: {
        message: "unauthorized"
      }, status: :unauthorized
    end
  end
end
