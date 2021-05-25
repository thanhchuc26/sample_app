class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:sessions][:email].downcase
    login_authenticate
  end

  def login_authenticate
    if @user&.authenticate params[:sessions][:password]
      activate_check
    else
      flash[:danger] = t "sessions.warning.session_error"
      render :new
    end
  end

  def activate_check
    if @user.activated?
      flash[:success] = t("sessions.warning.log_in_succes",
                          user_name: @user.name)
      log_in @user
      params[:sessions][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash[:warning] = t "users.warning.please_activated"
      redirect_to root_path
    end
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
