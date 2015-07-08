class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.string :name
      t.decimal :price, precision: 6, scale: 2
      t.string :image

      t.timestamps null: false
    end
  end
end
