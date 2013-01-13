class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  attr_accessible :firstname, :name, :company, :employment_id

  has_many :memberships
  has_many :projects, :through => :memberships
  has_many :timerecords
	has_many :messages
	has_many :projectnotes
	belongs_to :Employment
	has_many :employments
	has_many :employees, :through => :employments

  def to_s
    return self.email
  end

  def get_full_name
    return self.firstname + " " + self.name
  end
end
