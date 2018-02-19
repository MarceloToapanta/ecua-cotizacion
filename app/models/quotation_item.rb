class QuotationItem < ActiveRecord::Base
	belongs_to :quotation
	belongs_to :exam
end
