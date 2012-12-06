class Membership < ActiveRecord::Base
  attr_accessible :project_id, :user_id, :status

  belongs_to :user
  belongs_to :project
end
