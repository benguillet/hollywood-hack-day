class AddUsedUsersFields < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.datetime :remember_created_at
    end
  end
end
