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
    if logged_in?
			#Entry内のuser_idがcurrent_userと同じEntry
			@currentUserEntry = Entry.where(user_id: current_user.id)
			#Entry内のuser_idがMYPAGEのparams.idと同じEntry
		    @userEntry = Entry.where(user_id: @user.id)
		    	#@user.idとcurrent_user.idが同じでなければ
			    unless @user.id == current_user.id
			      @currentUserEntry.each do |cu|
			        @userEntry.each do |u|
			          #もしcurrent_user側のルームidと＠user側のルームidが同じであれば存在するルームに飛ぶ
			          if cu.room_id == u.room_id then
			            @isRoom = true
			            @roomId = cu.room_id
			          end
			        end
			      end
			      #ルームが存在していなければルームとエントリーを作成する
			      unless @isRoom
			        @room = Room.new
			        @entry = Entry.new
			      end
			    end
	  end
  end
  
  private

  def authorize_user
    @user = User.find(params[:id])
    redirect_to(root_path, danger: t('.unauthorized')) unless current_user.follows?(@user)
  end
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :last_name, :first_name, :nickname, :grade_and_class)
  end
end
