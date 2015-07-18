class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :customer, index: true, foreign_key: true
      t.datetime :delivery_time
      t.string :location
      t.text :notes

      t.timestamps null: false
    end
  end
end
