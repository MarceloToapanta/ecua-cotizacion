class QuotationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.quotation_mailer.new_quotation.subject
  #
  def new_quotation(quotation)
  	@quotation = quotation
    @approver = User.where(:rol => 2).last
    @saler = @quotation.company.user

    mail to: @approver.email, subject: "Nueva Cotización para #{@quotation.company.name}"
  end

  def quotation_approved(quotation)
    @quotation = quotation
    @approver = User.where(:rol => 2).last
    @saler = @quotation.company.user
    mail to: @saler.email, subject: "Cotización aprobada para #{@quotation.company.name}"
  end

  def quotation_rejected(quotation)
    @quotation = quotation
    @approver = User.where(:rol => 2).last
    @saler = @quotation.company.user
    mail to: @saler.email, subject: "Cotización rechazada para #{@quotation.company.name}"
  end

end
