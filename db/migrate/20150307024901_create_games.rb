class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.column :state, :text
      t.timestamps
    end
  end
end
