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

  def total_approved(num_week)
    total = 0
    if self.companies.any?
      self.companies.each do |company|
        total = total + company.quotations.approved.by_week(num_week).count
      end
    end
    total
  end

  def total_pendig(num_week)
    total = 0
    if self.companies.any?
      self.companies.each do |company|
        total = total + company.quotations.pendig.by_week(num_week).count
      end
    end
    total
  end

  def total_reject(num_week)
    total = 0
    if self.companies.any?
      self.companies.each do |company|
        total = total + company.quotations.by_week(num_week).reject.count
      end
    end
    total
  end

  def total(num_week)
    total = 0
    if self.companies.any?
      self.companies.each do |company|
        total = total + company.quotations.by_week(num_week).count
      end
    end
    total
  end



end
