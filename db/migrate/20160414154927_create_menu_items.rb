class CreateMenuItems < ActiveRecord::Migration[5.0]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.decimal :price
      t.string :image

      t.timestamps
    end
  end
end
