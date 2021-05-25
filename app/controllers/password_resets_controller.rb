class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
                only: [:edit, :update]

  def new; end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("reset_password.empty_pass"))
      render :edit
    elsif @user.update(user_params)
      login_url @user
      @user.update_column(:reset_digest, nil)
      flash[:success] = t "reset_password.reset_succes"
      redirect_to @user
    else
      render :edit
    end
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "reset_password.guide_reset"
      redirect_to root_url
    else
      flash.now[:danger] = t "reset_password.email_not_found"
      render :new
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:warning] = t("users.warning.user_not_found")
    redirect_to root_path
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "reset_password.warning_expired"
    redirect_to new_password_reset_url
  end
end
