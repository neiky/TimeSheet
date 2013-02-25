class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :firstname, :name, :company, :employment_id, :role
  # attr_accessible :title, :body

  has_many :clients
  has_many :memberships
  has_many :projects, :through => :memberships
  has_many :timerecords
  has_many :messages
  has_many :projectnotes
  belongs_to :employment
  has_many :employments
  has_many :employees, :through => :employments
  has_one :employer, :through => :employment
  has_many :contacts

  #after_create :create_employment
  before_destroy :check_inactive
  after_rollback :set_inactive, :on => :destroy

  def create_employment
    if self.employment == nil
      puts "creating employment"
      self.employment = Employment.create(:employer_id => self.id, :employee_id => 0, :workingtime_per_day => 28800, :employment_date => Date.today, :accepted => true)
      self.save!
    end
  end

  def check_inactive
    return !self.inactive
  end

  def set_inactive
    puts "user to be set inactive"
    unless self.destroyed?
      self.inactive = true
      self.save!
    end
  end

  def confirm!
    super
    create_employment
  end

  def to_s
    return self.email
  end

  def get_full_name
    if self.inactive
      return "Deleted User"
    end
    return self.firstname + " " + self.name
  end

  def has_role?(rolename)
    self.role.eql?(rolename)
  end

  def get_employment
    Employment.where("(employer_id = ? AND employee_id = 0) OR employee_id = ?", self.id, self.id).first
  end

  def count_businessdays(start_date, end_date)
    return (start_date.to_date..end_date.to_date).count{|d| !d.saturday? && !d.sunday? && !is_vacation?(d)}
  end

  def is_vacation?(date)
    return false
  end

  def get_timerecords_current_month
    return self.timerecords.where("start >= ? and start < ?", Date.today.beginning_of_month, Date.today.next_day)
  end

  def get_workingtime_current_month
    self.employment.workingtime_per_day * count_businessdays(Date.today.beginning_of_month, Date.today)
  end

  def get_timerecords_current_year
    return self.timerecords.where("start >= ? and start < ?", Date.today.beginning_of_year, Date.today.next_day)
  end

  def get_workingtime_current_year
    self.employment.workingtime_per_day * count_businessdays(Date.today.beginning_of_year, Date.today)
  end
end
