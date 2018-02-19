class AddPdfToQuotations < ActiveRecord::Migration
  def change
    add_column :quotations, :pdf, :binary
  end
end
