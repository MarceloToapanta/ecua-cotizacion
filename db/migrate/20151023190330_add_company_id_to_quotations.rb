class AddCompanyIdToQuotations < ActiveRecord::Migration
  def change
    add_column :quotations, :company_id, :integer, null: false
  end
end
