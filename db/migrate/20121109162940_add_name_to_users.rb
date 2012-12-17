class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :firstname, :string
    add_column :users, :name, :string
    add_column :users, :company, :string
  end
end
