class AddRejectedToQuotations < ActiveRecord::Migration
  def change
    add_column :quotations, :rejected, :boolean
  end
end
