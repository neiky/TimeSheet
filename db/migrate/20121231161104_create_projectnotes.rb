class CreateProjectnotes < ActiveRecord::Migration
  def change
    create_table :projectnotes do |t|
      t.references :sender
      t.references :project
      t.text :content

      t.timestamps
    end
    add_index :projectnotes, :sender_id
    add_index :projectnotes, :project_id
  end
end
