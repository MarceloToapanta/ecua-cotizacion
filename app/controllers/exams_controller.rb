class ExamsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :authenticate_user!
  before_action :set_exam, only: [:show, :edit, :update, :destroy]
  before_action :can_manage, only: [:new, :edit, :destroy, :index]

  # GET /exams
  # GET /exams.json
  def index
    @exams = Exam.all.page(params[:page]).per(12)
  end

  # GET /exams/1
  # GET /exams/1.json
  def show
  end

  # GET /exams/new
  def new
    @exam = Exam.new
    @exam.city_value = 0
    @exam.province_value = 0
    @exam.m_units_value = 0
  end

  # GET /exams/1/edit
  def edit
  end

  # POST /exams
  # POST /exams.json
  def create
    @exam = Exam.new(exam_params)

    respond_to do |format|
      if @exam.save
        format.html { redirect_to @exam, notice: 'El examen se creó correctamente.' }
        format.json { render :show, status: :created, location: @exam }
      else
        format.html { render :new }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exams/1
  # PATCH/PUT /exams/1.json
  def update
    any_change = false
    msj = 'El examen se ha actualizado correctamente.'

    if params[:change].present? && params[:change] == "yes" && params[:authorization_num].present?
      if params[:exam][:city_value].to_s != @exam.city_value.to_s || params[:exam][:province_value].to_s != @exam.province_value.to_s || params[:exam][:m_units_value].to_s != @exam.m_units_value.to_s
        any_change = true
      end
      if any_change.present?
        @exam.create_exam_update(params[:authorization_num]) 
        msj << " Valores cambiados exitosamente"
      else
        msj << " No se registraron cambios de valores para cirular nro: #{params[:authorization_num]}"
      end
    else
      if params[:exam][:city_value].to_s != @exam.city_value.to_s || params[:exam][:province_value].to_s != @exam.province_value.to_s || params[:exam][:m_units_value].to_s != @exam.m_units_value.to_s
        any_change = true
      end
      params[:exam].delete :city_value
      params[:exam].delete :province_value
      params[:exam].delete :m_units_value
    end

    if params[:change].present? && params[:change] == "yes" && !params[:authorization_num].present?
      alert = "No se actualizó los cambios de valores, por que no se ingresó nro. circular"
    end

    respond_to do |format|
      if alert.present?
        format.html { redirect_to @exam, alert: alert }
        format.json { render :show, status: :ok, location: @exam }
      elsif @exam.update(exam_params) 
        format.html { redirect_to @exam, notice: msj }
        format.json { render :show, status: :ok, location: @exam }
      else
        format.html { render :edit }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exams/1
  # DELETE /exams/1.json
  def destroy
    @exam.destroy
    respond_to do |format|
      format.html { redirect_to exams_url, notice: 'El examen fue eliminado con éxito.' }
      format.json { head :no_content }
    end
  end

  def get_values
    values = []
    @exam = Exam.find(params[:id])
    values << number_with_precision(@exam.city_value, :precision => 2) || 0 
    values << number_with_precision(@exam.province_value, :precision => 2) || 0  
    values << number_with_precision(@exam.m_units_value, :precision => 2) || 0  
    respond_to do |format|
      format.html { render json: values.to_json }
      format.json { render json: values.to_json }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exam_params
      params.require(:exam).permit(:code, :name, :activated,:city_value, :province_value,:m_units_value)
    end

    def can_manage
      unless Exam.can_edit(current_user)
        redirect_to root_path, alert: "El usuario #{current_user.name}, no puede gestionar exámenes"
      end
    end
end
