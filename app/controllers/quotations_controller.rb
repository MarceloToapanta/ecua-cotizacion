class QuotationsController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_quotation, only: [:show, :edit, :update, :destroy]
  before_action :get_company, except: [:search]
  before_action :can_edit, only: [:edit, :update, :destroy]
  before_action :can_create, only: [:new, :create]
  before_action :get_users, only: [:index, :search]
  skip_before_filter :verify_authenticity_token, :only => [:search]
  

  before_action :get_all_exams, only: [:new, :edit, :create, :update]

  

  # GET /quotations
  # GET /quotations.json
  def index
    @filter_by_company = false
    @quotations = Quotation.order(:created_at).reverse_order
    if @company.present?
      @quotations = @quotations.where(:company_id => @company.id)
      @filter_by_company = true
    else
      if params[:user].present?
        if params[:user] == "all"
          @quotations = @quotations.order(:created_at)
          @quotations_approved = @quotations.where(:approved => true).count
        else
          companies = Company.where(:user_id => params[:user].to_i)
          @filter_user = User.find(params[:user])
          company_ids = companies.map{|c| c.id}
          @quotations = @quotations.where(:company_id => company_ids).order(:created_at)
          @quotations_approved = @quotations.where(:approved => true).count
        end
      else
        companies            = Company.where(:user_id => current_user.id)
        @filter_user         = current_user
        company_ids          = companies.map{|c| c.id}
        @quotations          = @quotations.where(:company_id => company_ids).order(:created_at)
        @quotations_approved = @quotations.where(:approved => true).count
      end 
    end

    @quotations = @quotations.page(params[:page]).per(12)

  end

  # GET /quotations/1
  # GET /quotations/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = QuotationPdf.new(@quotation)
        send_data pdf.render, filename: "cotizacion_#{@quotation.created_at}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  # GET /quotations/new
  def new
    @quotation = Quotation.new
    @quotation.total_users = 1
    @quotation.quotation_items.build unless @quotation.quotation_items.any?
  end

  # GET /quotations/1/edit
  def edit
    if @quotation.approved || @quotation.rejected
      if @quotation.approved
        respond_to do |format|
          format.html { redirect_to current_user.rol == 1 ? quotations_path : quotations_path(:user => 'all'), alert: 'Cotización fue aprobada por ' + User.find(@quotation.user_appoved_id).name if @quotation.user_appoved_id }
          format.json { render :show, status: :ok, location: @quotation }
        end
      elsif @quotation.rejected
        respond_to do |format|
          format.html { redirect_to current_user.rol == 1 ? quotations_path : quotations_path(:user => 'all'), alert: 'Cotización fue rechazada' }
          format.json { render :show, status: :ok, location: @quotation }
        end
      end
    else
      @quotation.quotation_items.build unless @quotation.quotation_items.any?
      @company = @quotation.company unless @company.present?
    end
  end

  # POST /quotations
  # POST /quotations.json
  def create
    @quotation = Quotation.new(quotation_params)
    @quotation.company_id = @company.id 
    @quotation.date = Time.now
    if @quotation.approved
      @quotation.date_approved = Time.now
      @quotation.user_appoved_id = current_user.id
    end
    if current_user.rol != 3
      @quotation.approved = false 
    end

    @quotation.exam_number = 0
    num_no_exam = 0
    if quotation_params[:quotation_items_attributes].present?
      quotation_params[:quotation_items_attributes].map{|q| num_no_exam  += 1 if q[1][:exam_id] == '' }
      @quotation.exam_number = quotation_params[:quotation_items_attributes].count - num_no_exam
    end

    respond_to do |format|
      if @quotation.save
        # Save quotation items
        quotation_params[:quotation_items_attributes].each do |item|
          i = QuotationItem.new
          i.quotation_id = @quotation.id
          i.exam_id = item[1][:exam_id]
          i.city_unit = item[1][:city_unit]
          i.province_unit = item[1][:province_unit]
          i.m_units_unit = item[1][:m_units_unit]
          i.save if item[1][:exam_id].present?
        end

        format.html { redirect_to current_user.rol == 1 ? quotations_path : quotations_path(:user => 'all'), notice: 'Cotización fue creada con éxito.' }
        format.json { render :show, status: :created, location: @quotation }
      else
        @quotation.quotation_items.build unless @quotation.quotation_items.any?
        # session[:error_quotation] = "Asegurese de ingresar una descripcion y un archivo PDF"
        format.html { render :new }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotations/1
  # PATCH/PUT /quotations/1.json
  def update

    @quotation.exam_number = 0
    num_no_exam = 0
    if quotation_params[:quotation_items_attributes].present?
      quotation_params[:quotation_items_attributes].map{|q| num_no_exam  += 1 if (q[1][:exam_id] == '' || q[1][:_destroy] == '1')}
      @quotation.exam_number = quotation_params[:quotation_items_attributes].count - num_no_exam
    end

    if @quotation.approved || @quotation.rejected
      if @quotation.approved
        respond_to do |format|
          format.html { redirect_to current_user.rol == 1 ? quotations_path : quotations_path(:user => 'all'), alert: 'Cotización ya fue aprobada por ' + User.find(@quotation.user_appoved_id).name if @quotation.user_appoved_id }
          format.json { render :show, status: :ok, location: @quotation }
        end
      elsif @quotation.rejected
        respond_to do |format|
          format.html { redirect_to current_user.rol == 1 ? quotations_path : quotations_path(:user => 'all'), alert: 'Cotización fue rechazada' }
          format.json { render :show, status: :ok, location: @quotation }
        end
      end
    else
      respond_to do |format|
        if @quotation.update(quotation_params)

          if params[:quotation][:approved] == "approved"
            @quotation.approved = true
          elsif params[:quotation][:approved] == "rejected"
            @quotation.rejected = true
          else
            @quotation.approved = false
            @quotation.rejected = false
          end

          if @quotation.approved
            @quotation.rejected = false
            @quotation.date_approved = Time.now
            @quotation.user_appoved_id = current_user.id
            @quotation.save
            QuotationMailer.quotation_approved(@quotation).deliver_now
          else
            @quotation.date_approved = nil
            @quotation.user_appoved_id = nil
            @quotation.rejected = true
            @quotation.save
          end

          if @quotation.rejected
            QuotationMailer.quotation_rejected(@quotation).deliver_now
          end
          # if params[:quotation][:pdf]
          #   @quotation.pdf = params[:quotation][:pdf].read
          # end
          format.html { redirect_to current_user.rol == 1 ? quotations_path : quotations_path(:user => 'all'), notice: 'Cotización fue actualizada con éxito.' }
          format.json { render :show, status: :ok, location: @quotation }
        else
          if @quotation.exam_number == 0
            @quotation.quotation_items = []
            @quotation.quotation_items.build
          end
          format.html { render :edit }
          format.json { render json: @quotation.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /quotations/1
  # DELETE /quotations/1.json
  def destroy
    url = @company.present? ? company_quotations_path(@company) : quotations_path
    if current_user.rol == 3
      @quotation.destroy
      respond_to do |format|
        format.html { redirect_to url, notice: 'Cotización fue eliminada con éxito.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to url, alert: 'Usuario actual no puede eliminar cotización' }
        format.json { head :no_content }
      end
    end
    
  end

  def search
    
    # params[:page] = 1 if params[:page].nil?
    @quotations = Quotation.order(:created_at).reverse_order
    @quotations = @quotations.where("description ILIKE ?", "%#{params[:q]}%").page(params[:page]).per(12)
    
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quotation
      @quotation = Quotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quotation_params
      params.require(:quotation).permit(:company_id ,:date, :description, :user_appoved_id, :date_approved, :approved, :published, :pdf, :exam_id,:validity,:total_users, :city_total, :province_total, :m_units_total,:provinces, :mobile_units, :rejected, quotation_items_attributes: [:id, :exam_id, :quotation_id,:city_unit, :province_unit, :m_units_unit, :total_users, :_destroy])
    end

    def get_company
      if params[:company_id]
        @company = Company.find(params[:company_id])
      else
        @company = @quotation.company if @quotation.present?
      end
    end

    def get_users
      @users = current_user.rol == 3 ? User.all : User.where.not(rol: ['3']) 
    end

    def can_edit
      if current_user.rol == 1
        if @quotation.approved
          msj = "No es posible editar, cotización fue aprobada!"
        elsif @quotation.rejected
          msj = "No es posible editar, cotización fue rechazada!"
        else
          msj = "No es posible editar, cotización pendiente de aprobación"
        end

        # redirect_to company_quotations_path(@company.id), notice: msj if !@quotation.can_edit(current_user)
        redirect_to company_quotations_path(@company.id), alert: msj
      end
    end
    
    def can_create
      unless @company.enabled_for_new_quotation?
        msj = "No es posible crear cotización, la empresa tiene una cotización por aprobar"
        redirect_to company_quotations_path(@company.id), alert: msj
      end
    end

end
