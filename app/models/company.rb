class Company < ActiveRecord::Base
	validates :name, :presence => true
	validates_uniqueness_of :name, :message => '%{value} ya fue registrado en el sistema'
	validates :ruc, :presence => true
	validates_uniqueness_of :ruc, :message => '%{value} ya fue registrado en el sistema'
	validates :user_id, :presence => true
	belongs_to :user
	has_many :quotations


	def sector_fullname
		if self.sector.present?
			[["Educación","educacion"],["Financiero","financiero"],["Industrial","industrial"]]  
			if self.sector == "educacion"
				"Educación"
			elsif self.sector == "financiero"
				"Financiero"
			elsif self.sector == "industrial"
				"Industrial"
			else
				"N/A"
			end
		else
			"N/A"
		end
	end

	def enabled_for_new_quotation?
		last_quotation = self.quotations.last
		if last_quotation.present? && last_quotation.approved == false && (last_quotation.rejected == false || last_quotation.rejected == nil)
			false
		else
			true
		end
	end
	
end
