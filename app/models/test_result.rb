class TestResult < ApplicationRecord
  belongs_to :user

  validates :test_name, presence: true, length: { maximum: 255 }
  validates :score, presence: true, numericality: { less_than_or_equal_to: :max_score } 
  validates :max_score, presence: true, numericality: { greater_than_or_equal_to: 0 } 
  
  before_save :calculate_achievement_rate

  private

  def calculate_achievement_rate
    return if score.nil? || max_score.nil?
    self.achievement_rate = ((score.to_f / max_score) * 100).round
  end

  def self.user_test_results(user)
    where(user: user).pluck(:test_name, :achievement_rate)
  end
end