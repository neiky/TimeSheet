class CreateProjecttasks < ActiveRecord::Migration
  def change
    create_table :projecttasks do |t|
      t.string :name
      t.references :project
      t.boolean :billable

      t.timestamps
    end
    add_index :projecttasks, :project_id
  end
end
