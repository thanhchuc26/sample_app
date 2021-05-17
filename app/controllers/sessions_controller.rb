class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:sessions][:email].downcase
    login_authenticate
  end

  def login_authenticate
    if @user&.authenticate params[:sessions][:password]
      flash[:success] = t("sessions.warning.log_in_succes",
                          user_name: @user.name)
      log_in @user
      params[:sessions][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_to @user
    else
      flash[:danger] = t "sessions.warning.session_error"
      render :new
    end
  end

  def destroy
    logout_url
    redirect_to root_path
  end
end
