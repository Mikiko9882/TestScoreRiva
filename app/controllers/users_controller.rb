class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  
  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(created_at: :desc)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  def show
    @user = User.find(params[:id]).decorate
    @test_results_data = TestResult.user_test_results(@user)
    @average_achievement_rate = @user.average_achievement_rate
    @test_results = TestResult.where(user_id: @user.id).order(created_at: :desc)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :last_name, :first_name, :nickname, :grade_and_class)
  end
end
