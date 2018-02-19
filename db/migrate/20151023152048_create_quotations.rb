class CreateQuotations < ActiveRecord::Migration
  def change
    create_table :quotations do |t|
      t.datetime :date
      t.string :description
      t.integer :user_appoved_id
      t.datetime :date_approved
      t.boolean :approved
      t.boolean :published

      t.timestamps null: false
    end
  end
end
