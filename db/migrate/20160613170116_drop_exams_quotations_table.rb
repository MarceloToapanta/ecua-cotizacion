class DropExamsQuotationsTable < ActiveRecord::Migration
  def change
  	drop_table :exams_quotations
  end
end
