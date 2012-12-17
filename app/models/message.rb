class Message < ActiveRecord::Base
  attr_accessible :content, :recipient, :sender, :read

	belongs_to :sender, :class_name => "User"
	belongs_to :recipient, :class_name => "User"

  def to_s
    return self.content
  end
end
