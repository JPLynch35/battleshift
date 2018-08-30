class AddKillCountsToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :p1_kill_count, :integer, default: 0
    add_column :games, :p2_kill_count, :integer, default: 0
  end
end
