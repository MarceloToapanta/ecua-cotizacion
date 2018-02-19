class HomeController < ApplicationController
	before_action :authenticate_user!
  def index
  	# if user_signed_in?
  	# 	# @companies = Company.where(:user_id => current_user.id)
   #    @search = Company.search(params[:q])
  	# 	@companies = @search.result.order(:created_at).reverse_order.page(params[:page]).per(10)
  	# else
  	# 	redirect_to new_user_session_path
  	# end

    #Admin
    @admin_pen_quotations = Quotation.where(:approved => false).order(:created_at).reverse_order
     
    if current_user.rol == 1
      #Al Uers
      @companies = Company.where(:user_id => current_user.id).order(:created_at).reverse_order.limit(12)
      company_ids = @companies.map{|c| c.id}
      @quotations = Quotation.where(:company_id => company_ids).order(:created_at).reverse_order
    else
      #Admin and Approver
      @companies = Company.limit(12).order(:created_at).reverse_order
      @quotations = Quotation.all.order(:created_at).reverse_order
    end
    
    #num of months to show
    num_months = 6
    # Approved Quotations
    @app_quotations = @quotations.approved
    @app_months = get_last_months(@app_quotations, num_months)
    # Pendig Quotations
    @pen_quotations = @quotations.pendig
    @pen_months = get_last_months(@pen_quotations, num_months)

    # Reject Quotations
    @rec_quotations = @quotations.reject
    @rec_months = get_last_months(@rec_quotations, num_months)

    # User
    # @u_months = []
    # users = User.all.where(:rol => 1)
    # users.each do |user|
    #   @u_months << get_last_months_by_user(@app_quotations, num_months, user)
    # end
    
  end

  def reset_data
    require 'csv'
    # Clear database
    Rails.application.eager_load!
    ActiveRecord::Base.descendants.each { |c| c.delete_all unless c == ActiveRecord::SchemaMigration  }
    ActiveRecord::Base.connection.reset_pk_sequence!("users")
    ActiveRecord::Base.connection.reset_pk_sequence!("companies")
    ActiveRecord::Base.connection.reset_pk_sequence!("quotations")
    ActiveRecord::Base.connection.reset_pk_sequence!("quotation_items")
    ActiveRecord::Base.connection.reset_pk_sequence!("exams")
    ActiveRecord::Base.connection.reset_pk_sequence!("exam_updates")
    # Add users
    datafile = Rails.root + 'db/usuarios.csv'
    CSV.foreach(datafile, headers: true) do |row|
      user = User.where(:email => row[0]).last
      unless user.present?
        u = User.new
        u.email = row[0]
        u.name  = row[1]
        u.password = row[2]
        u.password_confirmation = row[2]
        u.rol = row[3]
        u.save
      end
    end

    # Add Companies
    datafile = Rails.root + 'db/empresas.csv'
    CSV.foreach(datafile, headers: true) do |row|
      company = Company.where(:name => row[0]).last
      unless company.present?
        c = Company.new
        c.name = row[0]
        c.ruc = row[1]
        c.direcction = row[2]
        c.sector = row[3]
        c.contact_name = row[4]
        c.contact_email = row[5]
        c.doctor_name = row[6]
        c.doctor_email = row[7]
        c.billing_name = row[8]
        c.billing_email = row[9]
        c.user_id = row[10]
        c.save
      end
    end

    # Add examenes
    datafile = Rails.root + 'db/examenes.csv'
    CSV.foreach(datafile, headers: true) do |row|
      exam = Exam.where(:name => row[0]).last
      unless exam.present?
        e = Exam.new
        e.code = row[0]
        e.name = row[1]
        e.activated = row[2]
        e.province_value = row[3]
        e.m_units_value = row[4]
        e.city_value = row[5]
        e.save
      end
    end

    # Add Quotarions
    datafile = Rails.root + 'db/quotations.csv'
    CSV.foreach(datafile, headers: true) do |row|

      q = Quotation.new
      q.description = row[1]
      q.exam_number = 1
      q.city_total = row[3].present? ? row[3].to_d : 0
      q.province_total = row[4].present? ? row[4].to_d : 0
      q.m_units_total = row[5].present? ? row[5].to_d : 0
      q.company_id = 1
      q.total_users = 1
      q.approved = rand(0..1) == 1 ? true : false
      q.rejected = rand(0..1) == 1 ? true : false
      q.created_at = rand((Time.now.to_date - 6.months)..Time.now.to_date)
      
      Rails.logger.info "=====save ====> #{q.save}"
      Rails.logger.info "=====errors ====> #{q.errors.full_messages}"
    end

    redirect_to root_path, alert: "Base de datos cargada"


  end

end
