class CreateTimerecords < ActiveRecord::Migration
  def change
    create_table :timerecords do |t|
      t.references :User
      t.references :Project
      t.datetime :start
      t.datetime :end
      t.time :duration
      t.text :description

      t.timestamps
    end
  end
end
