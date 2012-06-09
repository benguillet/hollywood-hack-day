class AddAccessTokenToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :access_token, :null => false, :default => ''
    end
  end
end
