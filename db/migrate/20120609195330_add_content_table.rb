class AddContentTable < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string  :user_id
      t.string  :url
      t.integer :rate_up
      t.integer :rate_down
    end
  end
end
