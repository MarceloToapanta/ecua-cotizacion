class QuotationPdf < Prawn::Document
	require 'action_view'
	include ActionView::Helpers::NumberHelper
	def initialize(quotation)
		super(top_margin: 70)
		@quotation = quotation
		text "Cotización para #{@quotation.company.name}", size: 20, style: :bold
		stroke_horizontal_rule
		# Informacion general
		move_down 20
		text "Informacion de cotización", size: 16, style: :bold
		move_down 10
		text "<b>Creado en: </b> #{@quotation.date.strftime('%d-%m-%Y')}", size: 12, inline_format: true
		move_down 10
		text "<b>Creado por: </b> #{@quotation.company.user.name}", size: 12, inline_format: true
		move_down 10
		text "<b>Vigencia: </b> #{@quotation.validity.present? ? @quotation.validity.strftime('%d-%m-%Y') : 'No definido'}", size: 12, inline_format: true
		move_down 10
		text "<b>Total usuarios: </b> #{@quotation.total_users}", size: 12, inline_format: true
		move_down 10
		text "<b>Aprobador por: </b> #{User.get_name_by_id(@quotation.user_appoved_id)}", size: 12, inline_format: true
		move_down 10
		text "<b>Fecha de aprobación: </b> #{@quotation.date_approved.strftime('%d-%m-%Y') if @quotation.date_approved}", size: 12, inline_format: true

		# Examenes
		move_down 20
		text "Lista de exámenes", size: 16, style: :bold
		line_items

		# Total
		move_down 10
		total = @quotation.city_total
		total += @quotation.province_total if @quotation.provinces
		total += @quotation.m_units_total	if @quotation.mobile_units
		
		# Resumen totales
		move_down 20
		text "Resumen totales", size: 16, style: :bold
		move_down 10
		text "<b>Subtotal por ciudad: </b> #{'$' + number_with_precision(@quotation.city_total, :precision => 2) || 0}", size: 12, inline_format: true
		move_down 10
		text "<b>Subtotal por provincia: </b> #{'$' + number_with_precision(@quotation.province_total, :precision => 2) || 0}", size: 12, inline_format: true
		move_down 10
		text "<b>Subtotal por provincia: </b> #{'$' + number_with_precision(@quotation.m_units_total, :precision => 2) || 0}", size: 12, inline_format: true
		move_down 10
		text "<b>TOTAL: </b> #{'$' + number_with_precision(@quotation.city_total, :precision => 2) || 0}", size: 12, inline_format: true

		# Firmas
		move_down 30

		text "_______________________________", size: 14
		move_down 20
		
		text "Representante #{@quotation.company.name}", size: 12,:indent_paragraphs => 10, style: :bold

		move_down 20

		text "_______________________________", size: 14
		move_down 10
		text "#{@quotation.company.user.name} ", size: 14, :indent_paragraphs => 10
		text "Vendedor Comercial  ", size: 12,:indent_paragraphs => 10, style: :bold

	end

	def line_items
		move_down 10
		table line_item_rows
	end

	def line_item_rows
		[["Nombre examen", "Valor en ciudad", "Valor en provincia", "Valor en unidad móvil"]] + 
		@quotation.quotation_items.map do |item|
			[item.exam.name, '$' + number_with_precision(item.city_unit, :precision => 2 ), @quotation.provinces ? '$' + number_with_precision(item.province_unit, :precision => 2) : '$0.00', @quotation.mobile_units ? '$' + number_with_precision(item.m_units_unit, :precision => 2 ) : '$0.00']
		end
		
	end
end