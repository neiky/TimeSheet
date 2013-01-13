class AddStatusToEmployments < ActiveRecord::Migration
  def change
    add_column :employments, :accepted, :boolean, :default => false
    add_column :employments, :num_vacation_days, :integer, :default => 0
    add_column :employments, :num_vacation_days_remaining, :integer, :default => 0
    add_column :employments, :employment_date, :date
  end
end
