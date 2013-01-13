class Employment < ActiveRecord::Base
  belongs_to :employer, :class_name => "User"
  belongs_to :employee, :class_name => "User"
  attr_accessible :workingtime_per_day, :employer_id, :employee_id, :num_vacation_days, :num_vacation_days_remaining, :accepted, :employment_date
end
