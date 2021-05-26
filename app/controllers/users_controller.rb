class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :show, :create]
  before_action :load_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :is_admin?, only: :destroy
  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.warning.please_check_mail"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "users.update.success"
      redirect_to @user
    else
      flash[:danger] = t "users.update.fail"
      render :edit
    end
  end

  def index
    @users = User.ordered_by_name_desc.paginate(page: params[:page],
              per_page: Settings.user.paginate.per_page)
  end

  def destroy
    name_delected = @user.name
    if @user.destroy
      flash[:success] = t("users.destroy.sucess", user_name: name_delected)
    else
      flash[:danger] = t("users.destroy.fail", user_name: name_delected)
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "users.warning.please_login"
    redirect_to login_path
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("users.warning.find_by_id")
    redirect_to root_path
  end

  def correct_user
    redirect_to root_path unless current_user?(@user)
  end

  def is_admin?
    redirect_to root_path unless current_user.admin?
  end
end
