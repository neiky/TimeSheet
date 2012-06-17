class Project < ActiveRecord::Base
  attr_accessible :description, :name, :planned_efforts, :Client_id

  has_many :memberships
  has_many :users, :through => :memberships
  has_many :timerecords, :dependent => :destroy
  
  belongs_to :Client
  
  def total_duration
    self.timerecords.all.sum{|timerecord| timerecord.duration.to_i}
  end

  def to_s
    return name
  end
end
