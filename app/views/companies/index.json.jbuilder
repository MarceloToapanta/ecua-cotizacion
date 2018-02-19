json.array!(@companies) do |company|
  json.extract! company, :id, :name, :ruc, :direcction, :sector, :contact_name, :contact_email, :doctor_name, :doctor_email, :billing_name, :billing_email
  json.url company_url(company, format: :json)
end
