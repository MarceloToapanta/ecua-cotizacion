class LimmitPdf < ActiveRecord::Migration
  def change
  	change_column :quotations, :pdf, :binary, :limit => 65535000
  end
end
