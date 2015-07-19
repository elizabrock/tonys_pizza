class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :menu_item

  validates_numericality_of :quantity, greater_than: 0, allow_blank: true, message: "must be 1 or more"
  validates_presence_of :menu_item_id, :quantity

  default_scope { includes(:menu_item).order("menu_items.name ASC") }

  def total
    return unless menu_item
    menu_item.price * quantity
  end
end
