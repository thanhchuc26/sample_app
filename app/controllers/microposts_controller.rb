class MicropostsController < ApplicationController
  before_action :logged_in?, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "micropost.create.success"
      redirect_to root_url
    else
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost.destroy.deleted"
    else
      flash[:danger] = t "micropost.destroy.fail"
    end
    redirect_to request.referer || root_path
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "micropost.warning.invalid_micropost"
    redirect_to request.referer || root_url
  end
end
