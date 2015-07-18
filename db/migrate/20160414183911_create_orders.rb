class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :customer, foreign_key: true
      t.datetime :delivery_time
      t.string :location
      t.text :notes

      t.timestamps
    end
  end
end
