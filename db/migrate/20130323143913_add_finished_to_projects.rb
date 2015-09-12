class AddFinishedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :finished, :Boolean, :default => :false
  end
end
