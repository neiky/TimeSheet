class AddDetailsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :subject, :string
    add_column :messages, :read, :boolean, :default => false
  end
end
