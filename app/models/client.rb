class Client < ActiveRecord::Base
  attr_accessible :description, :name, :user_id

  has_many :projects, :dependent => :destroy
  has_many :contacts, :dependent => :destroy

  belongs_to :User

  def to_s
    return self.name
  end
end
