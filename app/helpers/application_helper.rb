module ApplicationHelper
	def get_user_by_id(id)
		user = User.find(id)    
	end

	def get_rol_name(id)
		if id == 1
			"Comercial"
		elsif id == 2
			"Supervisor"
		elsif id == 3
			"Administrador"
		end
	end
	def peding_count
		if current_user.rol == 3
			quotations = Quotation.where(:approved => false).count
		else
			companies = Company.where(:user_id => current_user.id)
			company_ids = companies.map{|c| c.id}
			quotations = Quotation.where(:company_id => company_ids, :approved => false).count
		end
	end

	

end
