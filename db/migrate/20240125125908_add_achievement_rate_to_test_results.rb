class AddAchievementRateToTestResults < ActiveRecord::Migration[5.2]
  def change
    add_column :test_results, :achievement_rate, :float
  end
end
