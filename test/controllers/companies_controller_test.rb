require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  setup do
    @company = companies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:companies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create company" do
    assert_difference('Company.count') do
      post :create, company: { billing_email: @company.billing_email, billing_name: @company.billing_name, contact_email: @company.contact_email, contact_name: @company.contact_name, direcction: @company.direcction, doctor_email: @company.doctor_email, doctor_name: @company.doctor_name, name: @company.name, ruc: @company.ruc, sector: @company.sector }
    end

    assert_redirected_to company_path(assigns(:company))
  end

  test "should show company" do
    get :show, id: @company
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @company
    assert_response :success
  end

  test "should update company" do
    patch :update, id: @company, company: { billing_email: @company.billing_email, billing_name: @company.billing_name, contact_email: @company.contact_email, contact_name: @company.contact_name, direcction: @company.direcction, doctor_email: @company.doctor_email, doctor_name: @company.doctor_name, name: @company.name, ruc: @company.ruc, sector: @company.sector }
    assert_redirected_to company_path(assigns(:company))
  end

  test "should destroy company" do
    assert_difference('Company.count', -1) do
      delete :destroy, id: @company
    end

    assert_redirected_to companies_path
  end
end
