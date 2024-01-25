class TestResultsController < ApplicationController
  before_action :find_test_result, only: [:edit, :update, :destroy]

  def index
    @test_results = TestResult.all.includes(:user).order(created_at: :desc)
  end
end
