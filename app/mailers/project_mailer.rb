class ProjectMailer < ActionMailer::Base
	default from: "test@timerecorder.com"

	def project_invitation(owner, member, project)
		@member = member
		@owner = owner
		@project = project
		if Rails.env.development?
			recipent = "michi.neiky@googlemail.com"
			subject = "[#{member.email}] Project invitation"
    	else
			recipent = user.email
			subject = "Project invitation"
		end
		mail(:to => recipent, :subject => subject)
	end

	def project_invitation_rejected(owner, member, project)
		@member = member
		@owner = owner
		@project = project
		if Rails.env.development?
			recipent = "michi.neiky@googlemail.com"
			subject = "[#{owner.email}] Project invitation rejected"
    	else
			recipent = owner.email
			subject = "Project invitation rejected"
		end
		mail(:to => recipent, :subject => subject)
	end

	def project_invitation_accepted(owner, member, project)
		@member = member
		@owner = owner
		@project = project
		if Rails.env.development?
			recipent = "michi.neiky@googlemail.com"
			subject = "[#{owner.email}] Project invitation accepted"
    	else
			recipent = owner.email
			subject = "Project invitation accepted"
		end
		mail(:to => recipent, :subject => subject)
	end
end
