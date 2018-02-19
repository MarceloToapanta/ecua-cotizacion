class AddNewFieldsToQuotation < ActiveRecord::Migration
  def change
  	add_column :quotations, :validity, :datetime
  	add_column :quotations, :total_users, :integer
  	add_column :quotations, :provinces, :boolean
  	add_column :quotations, :medical_center, :boolean
  	add_column :quotations, :mobile_units, :boolean
  	add_column :quotations, :city_total, :decimal
  	add_column :quotations, :province_total, :decimal
  	add_column :quotations, :m_units_total, :decimal
  end
end
