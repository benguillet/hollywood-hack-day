class AddImportedFromFbToUsers < ActiveRecord::Migration
  def change
    add_column :users, :imported_from_fb, :integer, :default => 0
  end
end
