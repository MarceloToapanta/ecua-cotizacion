class Quotation < ActiveRecord::Base
	#Relations
	belongs_to :company
	has_many :quotation_items, :dependent => :destroy
	accepts_nested_attributes_for :quotation_items, reject_if: proc { |attributes| attributes['exam_id'].blank? ||  attributes['quotation_id'].blank?}, allow_destroy: true

	mount_uploader :pdf, PdfUploader
	# Validations
	validates :description, :presence => true
	validates :total_users, :numericality => { :greater_than => 0}
	# validates_attachment_content_type :pdf, :content_type => /\Aapplication\/pdf/
	
	# validates :quotation_items, length: { minimum: 1, maximum: 1000 }
	validates :exam_number, :numericality => { :greater_than => 0}
	


	# after_create :send_create_notification

	def total
		province_total = self.provinces ? self.province_total : 0
		m_units_total = self.mobile_units ? self.m_units_total : 0
		total = self.city_total + province_total + m_units_total
	end

	def can_edit(user)
		if user.rol == 1
			if self.approved || self.rejected || self.company.user.id != user.id
				false
			else
				true
			end
		else
			true
		end
	end

	def send_create_notification
    QuotationMailer.new_quotation(self).deliver_now
	end

	class << self

		def approved
			where(:approved => true, :rejected => [false, nil])
		end

		def pendig
			where(:approved => false, :rejected => [false, nil])
		end

		def reject
			where(:rejected => true)
		end

	end
end
