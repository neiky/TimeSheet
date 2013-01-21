class Contact < ActiveRecord::Base
	belongs_to :user
  belongs_to :client
  attr_accessible :comment, :email, :firstname, :name, :phone, :client, :client_id, :user

  def to_s
	  if !self.firstname
			return self.name
		else
			if !self.name
				return self.firstname
			else
				return self.firstname + " " + self.name
			end
	  end
	 end
end