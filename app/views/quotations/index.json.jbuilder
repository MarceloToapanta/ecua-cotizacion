json.array!(@quotations) do |quotation|
  json.extract! quotation, :id, :date, :description, :user_appoved_id, :date_approved, :approved, :published
  json.url quotation_url(quotation, format: :json)
end
