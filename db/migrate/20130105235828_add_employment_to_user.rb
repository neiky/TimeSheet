class AddEmploymentToUser < ActiveRecord::Migration
  def change
  	add_column :users, :employment_id, :integer
  end
end
