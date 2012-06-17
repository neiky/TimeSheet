class Client < ActiveRecord::Base
  attr_accessible :description, :name
  
  has_many :projects, :dependent => :destroy
  
  def to_s
    return self.name
  end
end
