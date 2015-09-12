class AddIndexInactiveToUser < ActiveRecord::Migration
  def change
    add_index :users, :inactive
  end
end
