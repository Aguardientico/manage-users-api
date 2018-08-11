class SessionController < ApplicationController
  skip_before_action :authenticate
  skip_before_action :should_be_admin

  def create
    user = User.login(email: params[:email], password: params[:password])
    if user
      response.headers['Token'] = user.jwt_token
      render json: user, status: :ok
    else
      render json: {
        message: "unauthorized"
      }, status: :unauthorized
    end
  end
end
