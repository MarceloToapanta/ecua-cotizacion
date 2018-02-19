class UsersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :authenticate_user!
  
  # GET /exams/new
  def new
    @user = User.new
  end

  # POST /exams
  # POST /exams.json
  def create_seller
    @user = User.new(user_params)
    @user.rol = 1
    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: 'Vendedor registrado correctamente.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
