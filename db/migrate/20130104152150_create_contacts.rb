class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :firstname
      t.string :email
      t.string :phone
      t.references :client
      t.text :comment

      t.timestamps
    end
    add_index :contacts, :client_id
  end
end
