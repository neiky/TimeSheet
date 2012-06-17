class ProjectClientAndPlannedEfforts < ActiveRecord::Migration
  def up
    add_column :projects, :planned_efforts, :integer, :default => 0
    add_column :projects, :Client_id, :integer
  end

  def down
    remove_column :projects, :planned_efforts
    remove_column :projects, :Client_id
  end
end
