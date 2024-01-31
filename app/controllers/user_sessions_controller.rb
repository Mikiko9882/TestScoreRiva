class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  
  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      cookies.signed[:user_id] = { value: @user.id, expires: 1.week.from_now }
      # ユーザーIDを暗号化してクッキーに保存
      cookies.encrypted[:user_id] = { value: @user.id, expires: 1.week.from_now }
      
      redirect_back_or_to test_results_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, success: t('.success')
  end
end
