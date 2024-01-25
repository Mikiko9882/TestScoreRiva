class CreateTestResults < ActiveRecord::Migration[5.2]
  def change
    create_table :test_results do |t|
      t.string :test_name, null: false
      t.integer :score, null: false
      t.integer :max_score, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
