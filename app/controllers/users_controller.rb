class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by_id params[:id]
    if @user.nil?
      flash[:danger] = t("users.warning.find_by_id")
      redirect_to root_path
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "users.new_succ"
      redirect_to @user
    else
      flash.now[:danger] = t "users.new_fail"
      render :new
    end
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end
end
