class Public::UsersController < ApplicationController
   before_action :is_matching_login_user, only: [:edit, :update, :show]
   before_action :ensure_guest_user, only: [:edit]
  def show
    @user = User.find(params[:id])
    @subjects = Subject.where(status: true)
    @subject = @subjects.where(user_id: current_user.id)
  end

  def index
   
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:nickname, :email, :profile_image, :introduction)
  end
  
  def is_matching_login_user
    user_id = params[:id].to_i
    unless user_id == current_user.id
      redirect_to root_path
    end
  end
  
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.nickname == "guestuser"
      redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end  
  
end
