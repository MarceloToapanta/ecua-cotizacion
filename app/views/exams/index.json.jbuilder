json.array!(@exams) do |exam|
  json.extract! exam, :id, :code, :name, :activated
  json.url exam_url(exam, format: :json)
end
