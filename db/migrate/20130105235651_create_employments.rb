class CreateEmployments < ActiveRecord::Migration
  def change
    create_table :employments do |t|
      t.references :employer
      t.references :employee
      t.time :workingtime_per_day

      t.timestamps
    end
    add_index :employments, :employer_id
    add_index :employments, :employee_id
  end
end
