class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :check_admin, only: :destroy

  def index
    @users = User.paginate(page: params[:page], per_page: Settings.number_10)
  end

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "welcome_to_app"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      flash.now[:danger] = t "update_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to users_url
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def logged_in_user
    return if logged_in?


    store_location
    flash[:danger] = t "please_log_in"
    redirect_to login_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t "not_permission"
    redirect_to root_url
  end

  def check_admin
    return if current_user.admin?

    flash[:danger] = t "is_admin"
    redirect_to root_url
  end
end
