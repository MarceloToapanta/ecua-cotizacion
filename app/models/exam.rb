class Exam < ActiveRecord::Base
	has_many :quotation_items
	has_many :exam_updates

	validates :code, :presence => true, :uniqueness => true
	validates :name, :presence => true, :uniqueness => true

	validates :city_value, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }
	validates :m_units_value, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }
	validates :province_value, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }

	class << self
		def can_edit(user)
			if user.rol == 3
				true
			else
				false
			end
		end
	end

	def create_exam_update(authorization_num)
		item = ExamUpdate.new		
		item.authorization = authorization_num
		item.exam_id = self.id
		item.date_modification = Time.now
		item.description = "Valores anteriores del examen: Valor unitario por Ciudad #{self.city_value}, Valor unitario por Provicia: #{self.province_value}, Valor unitario por Unidades móviles: #{m_units_value}"
		item.save
	end

end
