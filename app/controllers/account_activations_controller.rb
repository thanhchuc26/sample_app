class AccountActivationsController < ApplicationController
  before_action :find_email

  def edit
    if !@user.activated && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t "users.warning.activated"
      redirect_to @user
    else
      flash[:danger] = t "users.warning.invalid_activated"
      redirect_to root_url
    end
  end

  private

  def find_email
    @user = User.find_by email: params[:email]
    return if @user

    flash[:warning] = t "error_messages.email_not_found"
    redirect_to root_url
  end
end
