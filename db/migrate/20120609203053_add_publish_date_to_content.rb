class AddPublishDateToContent < ActiveRecord::Migration
  def change
    change_table :contents do |t|
      t.datetime :post_date
    end
  end
end
