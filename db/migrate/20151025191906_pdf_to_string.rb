class PdfToString < ActiveRecord::Migration
  def change
  	change_column :quotations, :pdf, :string
  end
end
