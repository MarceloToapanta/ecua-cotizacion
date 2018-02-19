class CreateQuotationItems < ActiveRecord::Migration
  def change
    create_table :quotation_items do |t|
      t.integer :quotation_id
      t.integer :exam_id
      t.decimal :city_unit
      t.decimal :province_unit
      t.decimal :m_units_unit
      t.string :description

      t.timestamps null: false
    end
  end
end
