class Membership < ActiveRecord::Base
  attr_accessible :project_id, :user_id, :status

  belongs_to :user
  belongs_to :project

  #after_destroy :send_rejection_mail, :if => "self.status.eql?(0)"

  def send_rejection_mail
		ProjectMailer.project_invitation_rejected(self.project.owner, self.user, self.project).deliver
  end
end
