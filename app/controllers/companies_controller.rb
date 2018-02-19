class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_action :get_sector
  # GET /companies
  # GET /companies.json
  def index
    unless current_user.rol == 3
      @companies = Company.where(:user_id => current_user.id).order(created_at: :desc).page(params[:page]).per(20)
    else
      @companies = Company.all.page params[:page]
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
    
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    @company.user_id = current_user.id
    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Empresa creada correctamente.' }
        format.json { render :show, status: :created, location: @company }
      else
        @company.errors.full_messages.each do |error|
          if error.include?('Ruc') && error.include?('ya fue registrado en el sistema')
            company_created = Company.where(:ruc => params[:company][:ruc]).first
            if company_created
              @company.errors[:base] << "El ruc <strong>#{params[:company][:ruc]}</strong> fue registrado por el usuario: <strong>#{company_created.user.name}</strong> (#{company_created.user.email})".html_safe
              @company.errors.messages.delete(:ruc)
            end
          end
          if error.include?('Nombre') && error.include?('ya fue registrado en el sistema')
            company_created = Company.where(:name => params[:company][:name]).first
            if company_created
              @company.errors[:base] << "El nombre <strong>#{params[:company][:name]}</strong> fue registrado por el usuario: <strong>#{company_created.user.name}</strong> (#{company_created.user.email})".html_safe
              @company.errors.messages.delete(:name)
            end
          end
        end
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    @company.user_id = current_user.id
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Empresa actualizada correctamente.' }
        format.json { render :show, status: :ok, location: @company }
      else

        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    if current_user.rol == 1
      respond_to do |format|
        format.html { redirect_to companies_url, alert: 'No es posible eliminar esta empresa.' }
        format.json { head :no_content }
      end
    else
      @company.destroy
      respond_to do |format|
        format.html { redirect_to companies_url, notice: 'Empresa eliminada correctamente.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :ruc, :direcction, :sector, :contact_name, :contact_email, :doctor_name, :doctor_email, :billing_name, :billing_email, :description)
    end

    def get_sector
      @sectors = [["Educación","educacion"],["Financiero","financiero"],["Industrial","industrial"]]
    end
end
