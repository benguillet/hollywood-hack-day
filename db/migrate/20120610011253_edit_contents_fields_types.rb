class EditContentsFieldsTypes < ActiveRecord::Migration
  def change
    change_table :contents do |t|
      t.change :user_id,   :integer,  :null => false
      t.change :url,       :string,   :null => false
      t.change :rate_up,   :integer,  :null => false, :default => 0
      t.change :rate_down, :integer,  :null => false, :default => 0
      t.change :post_date, :datetime, :null => false
      t.change :source,    :string,   :null => false
    end
  end
end
