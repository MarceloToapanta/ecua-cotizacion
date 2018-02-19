class AddNameExmanInRelation < ActiveRecord::Migration
  def change
  	rename_column :exams_quotations, :examn_id, :exam_id
  end
end
