class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_user
  before_filter :set_date_format

  def set_user
    if User.count == 0
      first_user = User.new
      first_user.id = "1"
      first_user.name = "Administrador del Sistema"
      first_user.email = "admin@cotizacion.com"
      first_user.password_confirmation = "admin"
      first_user.password = "admin"
      first_user.rol = 3
      first_user.save
    end
  end

  def set_date_format
    @date_format = "%d-%m-%Y"
    @date_time_format = "%d-%m-%Y %I:%M"
  end  

  def get_all_exams
    @all_exams = Exam.where(:activated => true).order(:name)
  end

  def get_last_months(app_quotations ,num_months = 6)
    year = Time.now.year
    app_months = []
    (1..num_months).each do |i|
      month_name = get_month_name(((Date.today - num_months.months) + i.months).strftime("%B"))
      month_num = ((Date.today - num_months.months) + i.months).strftime("%-m")
      val = app_quotations.where('extract(month from created_at) = ?', month_num).where('extract(year from created_at) = ?', year).count
      app_months << [month_name,val]
    end
    app_months
  end

  def get_month_name(month)
    months = {"January" => "Enero", "February" => "Febrero", "March" => "Marzo", "April" => "Abril", "May" => "Mayo", "June" => "Junio", "July" => "Julio", "August" => "Agosto", "September" => "Septiembre", "October" => "Octubre", "November" => "Noviembre", "December" => "Diciembre" }
    months[month]
  end

end
