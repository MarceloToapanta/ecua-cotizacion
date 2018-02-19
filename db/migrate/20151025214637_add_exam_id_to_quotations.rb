class AddExamIdToQuotations < ActiveRecord::Migration
  def change
    add_column :quotations, :exam_id, :integer
  end
end
