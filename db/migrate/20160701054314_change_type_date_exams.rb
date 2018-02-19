class ChangeTypeDateExams < ActiveRecord::Migration
  def change
  	remove_column :exams, :city_value
  	add_column :exams, :city_value, :decimal
  end
end
