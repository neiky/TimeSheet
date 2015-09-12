class AddProjecttaskToProject < ActiveRecord::Migration
  def change
    add_column :projects, :projecttask_id, :integer
  end
end
