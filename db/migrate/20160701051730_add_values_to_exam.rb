class AddValuesToExam < ActiveRecord::Migration
  def change
  	add_column :exams, :city_value, :datetime
  	add_column :exams, :province_value, :decimal
  	add_column :exams, :m_units_value, :decimal
  end
end
