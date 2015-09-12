class AddMaxProjectsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :maxNumProjects, :Integer, :default => 3
    add_column :users, :maxNumMembershipsForOwnProjects, :Integer, :default => 3
  end
end
