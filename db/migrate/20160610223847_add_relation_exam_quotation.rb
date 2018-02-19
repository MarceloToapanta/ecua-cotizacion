class AddRelationExamQuotation < ActiveRecord::Migration
  def change
  	create_table :quotations_examns, id: false do |t|
      t.belongs_to :quotation, index: true
      t.belongs_to :examn, index: true
    end
  end
end
