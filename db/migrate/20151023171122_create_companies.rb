class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :ruc
      t.string :direcction
      t.string :sector
      t.string :contact_name
      t.string :contact_email
      t.string :doctor_name
      t.string :doctor_email
      t.string :billing_name
      t.string :billing_email

      t.timestamps null: false
    end
  end
end
