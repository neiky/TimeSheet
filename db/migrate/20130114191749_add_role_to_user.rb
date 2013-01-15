class AddRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, :default => 'user', :limit => 30
  end
end
