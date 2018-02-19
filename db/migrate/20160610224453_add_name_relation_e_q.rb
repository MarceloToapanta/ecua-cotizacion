class AddNameRelationEQ < ActiveRecord::Migration
  def change
  	rename_table :quotations_examns, :exams_quotations
  end
end
