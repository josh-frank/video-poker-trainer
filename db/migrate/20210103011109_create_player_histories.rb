class CreatePlayerHistories < ActiveRecord::Migration[5.2]
  
  def change
    create_table :player_histories do | t |
      t.integer :player_id
      t.integer :player_answers
      t.integer :correct_answers
      t.integer :right_holds
      t.integer :total_holds
      t.float :average_time
      t.timestamps
    end
  end

end
