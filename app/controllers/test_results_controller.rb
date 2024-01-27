class TestResultsController < ApplicationController
  before_action :find_test_result, only: [:edit, :update, :destroy]

  def index
    user_ids_to_display = [current_user.id, *current_user.following_ids]
    @user_achievements = User.where(id: user_ids_to_display)
                             .pluck(:id, :nickname)
                             .map { |user_id, nickname| [nickname, TestResult.where(user_id: user_id).average(:achievement_rate).to_f] }
    @test_results = TestResult.where(user_id: user_ids_to_display).order(created_at: :desc).page(params[:page])
  end

  def new
    @test_result = TestResult.new
  end

  def create
    @test_result = current_user.test_results.build(test_result_params)
    if @test_result.save
      redirect_to test_results_path, success: t('defaults.message.created', item: TestResult.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.not_created', item: TestResult.model_name.human)
      render :new
    end
  end

  def show
    @test_result = TestResult.find(params[:id])
  end

  def edit; end

  def update
    if @test_result.update(test_result_params)
      redirect_to @test_result, success: t('defaults.message.updated', item: TestResult.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.not_updated', item: TestResult.model_name.human)
      render :edit
    end
  end

  def destroy
    @test_result.destroy!
    redirect_to test_results_path, success: t('defaults.message.deleted', item: TestResult.model_name.human)
  end

  def my_results
    # ログインユーザーだけのテスト結果を取得
    @my_test_results = current_user.test_results.order(created_at: :desc).page(params[:page])
  end

  private

  def find_test_result
    @test_result = current_user.test_results.find(params[:id])
  end

  def test_result_params
    params.require(:test_result).permit(:test_name, :score, :max_score)
  end
end
