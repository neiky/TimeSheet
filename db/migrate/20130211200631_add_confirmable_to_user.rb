class AddConfirmableToUser < ActiveRecord::Migration
  def up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string    # Only if using reconfirmable

    add_index :users, :confirmation_token, :unique => true

    User.all.each do |user|
      user.confirm!
    end
  end
  def down
    remove_index :users, :confirmation_token

    remove_column :users, :confirmation_token
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_sent_at
    remove_column :users, :unconfirmed_email    # Only if using reconfirmable
  end
end
