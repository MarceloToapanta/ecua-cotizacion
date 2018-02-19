class CreateExamUpdates < ActiveRecord::Migration
  def change
    create_table :exam_updates do |t|
      t.string :authorization
      t.text :description
      t.datetime :date_modification
      t.integer :exam_id

      t.timestamps null: false
    end
  end
end
