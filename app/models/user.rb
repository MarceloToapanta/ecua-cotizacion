class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  devise :database_authenticatable, :rememberable, :trackable, :validatable, :recoverable, :registerable

  #Validations
  validates_presence_of :name, :password_confirmation
  has_many :companies
  class << self
	  def get_name_by_id(id)
	  	User.find(id).name
	  end
	end

end
