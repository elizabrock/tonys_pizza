class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :menu_item

  default_scope { includes(:menu_item).order("menu_items.name ASC") }

  def total
    return unless menu_item
    menu_item.price * quantity
  end
end
