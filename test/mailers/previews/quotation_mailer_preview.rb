# Preview all emails at http://localhost:3000/rails/mailers/quotation_mailer
class QuotationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/quotation_mailer/new_quotation
  def new_quotation
  	quotation = Quotation.last
    QuotationMailer.new_quotation(quotation)
  end

end
