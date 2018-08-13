class UsersController < ApplicationController
  before_action :load_user, only: %i[show update destroy]

  def index
    users = User.search(params[:term], params[:page])
    response.headers['X-Total-Pages'] = users.total_pages.to_s
    render json: users
  end

  def show
    render json: @user
  end

  def create
    user = User.create(create_user_params)
    if user.persisted?
      render json: user, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    @user.destroy
    render json: { id: params[:id] }, status: :ok
  end

  private

  def load_user
    @user = User.find_by!(hashed_id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Not found' }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :job_title)
  end

  def create_user_params
    params.require(:user).permit(:first_name, :last_name, :job_title, :email, :password)
  end
end
