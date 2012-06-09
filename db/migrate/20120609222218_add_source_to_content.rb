class AddSourceToContent < ActiveRecord::Migration
  def change
    add_column :contents, :source, :string
  end
end
