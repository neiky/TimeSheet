class Projectnote < ActiveRecord::Base
  belongs_to :sender, :class_name => "User"
  belongs_to :project
  attr_accessible :content

  default_scope order: 'Projectnotes.created_at DESC'
end
