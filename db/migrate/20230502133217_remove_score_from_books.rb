class RemoveScoreFromBooks < ActiveRecord::Migration[6.1]
  def change
    remove_column :books, :score, :integer
  end
end
