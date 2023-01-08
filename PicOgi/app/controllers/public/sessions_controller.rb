# frozen_string_literal: true
class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  private
  
   def after_sign_in_path_for(resource)
     public_homes_top_path
   end
   
   def after_sign_out_path_for(resource)
     public_root_path
   end
  
   def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :nickname, :introduction])
   end
  
# 退会しているかを判断するメソッド
 def user_state
  ## 【処理内容1】 入力されたemailからアカウントを1件取得
   #       モデル名.find_by(カラム名: 検索する値)
    @user = User.find_by(email: params[:user][:email])
    
  ## アカウントを取得できなかった場合、このメソッドを終了する
  return if !@user
  
  ## 【処理内容2】 取得したアカウントのパスワードと入力されたパスワードが一致してるかを判別
   #  ユーザー情報.valid_password?(入力されたパスワード)
    if @user.valid_password?(params[:user][:password]) && !@user.is_deleted
    else
      redirect_to  "/users/sign_up"
    end
 end
 
end