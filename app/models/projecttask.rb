class Projecttask < ActiveRecord::Base
  belongs_to :project
  attr_accessible :billable, :name
end
