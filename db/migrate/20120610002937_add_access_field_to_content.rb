class AddAccessFieldToContent < ActiveRecord::Migration
  def change
    change_table :contents do |t|
      t.string :access, :null => false, :default => 'friends'
    end
  end
end
