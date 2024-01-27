class Admin::TestResultsController < Admin::BaseController
  before_action :find_test_result, only: [:edit, :update, :show, :destroy]

  def index
    @q = TestResult.ransack(params[:q])
    @test_results = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
  end

  def edit; end

  def update
    if @test_result.update(test_result_params)
      redirect_to admin_test_result_path(@test_result), success: t('defaults.message.updated', item: TestResult.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.not_updated', item: TestResult.model_name.human)
      render :edit
    end
  end

  def show; end

  def destroy
    @test_result.destroy!
    redirect_to admin_test_results_path, success: t('defaults.message.deleted', item: TestResult.model_name.human)
  end

  private

  def find_test_result
    @test_result = TestResult.find(params[:id])
  end

  def test_result_params
    params.require(:test_result).permit(:test_name, :score, :max_score)
  end
end
