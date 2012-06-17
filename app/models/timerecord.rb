class Timerecord < ActiveRecord::Base
  attr_accessible :Project, :description, :end, :start

  belongs_to :User
  belongs_to :Project
  
  #validates :duration, :greater_than => 0
  
  #scope :group_by_client, :joins => :client, :group => :client_id, :select => "*, clients.name as client_name, sum(amount) as amount"
  scope :group_by_project, :joins => :project, :group => :project_id, :select => "*, projects.name as project_name, sum(duration) as duration"
  scope :group_by_user, :joins => :project, :group => :user_id, :select => "*, users.name as user_name, sum(duration) as duration"
  
  
  def self.by_user_id(id)
    where(:user_id => id)
  end
  
  def self.by_project_id(id)
    where(:project_id => id)
  end
  
  def self.get_timerecords(params)
    date = Date.today() unless params[:date] or params[:date_search]
    date = Date.strptime(params[:date_search], '%Y-%m-%d') if params[:date_search]
    date = Date.strptime(params[:date], '%Y-%m-%d') if params[:date]
    
    timerecords = Timerecord.order("start DESC").find(:all, :conditions => ['start >= ? and start < ?', date, date+1])
    
    return timerecords
  end
  
  def self.get_sum_duration(timerecords)
    total_duration = 0
    if timerecords
      timerecords.each do |record|
        total_duration = total_duration + record.duration
      end
    end
    
    return total_duration
  end
  
  def self.in_period(start_date, end_date)
    where("start >= ? and start < ?", start_date, end_date+1)
  end
end
