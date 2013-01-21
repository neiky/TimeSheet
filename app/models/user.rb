class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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

  def to_s
    return self.email
  end

  def get_full_name
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
end
