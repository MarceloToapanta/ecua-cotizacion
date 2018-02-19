class AddExamNumberToQuotations < ActiveRecord::Migration
  def change
    add_column :quotations, :exam_number, :integer
  end
end
