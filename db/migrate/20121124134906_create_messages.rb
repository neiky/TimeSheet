class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :sender
      t.references :recipient
      t.string :content

      t.timestamps
    end
  end
end
