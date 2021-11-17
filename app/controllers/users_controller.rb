class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit)

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "welcome_to_app"
      redirect_to :root
    else
      render :new
    end
  end

  def edit; end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to signup_path
  end
end
