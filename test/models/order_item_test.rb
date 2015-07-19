require 'test_helper'

class OrderItemTest < ActiveSupport::TestCase
  test "total is based on item quantity and price" do
    menu_item = MenuItem.new(price: 13.99)
    order_item = OrderItem.new(menu_item: menu_item, quantity: 3)
    assert_equal 41.97, order_item.total
    order_item.quantity = 1
    assert_equal 13.99, order_item.total
  end

  test "total returns nil if there is no menu item" do
    order_item = OrderItem.new()
    assert_nil order_item.total
  end

  test "requires menu_item" do
    order_item = OrderItem.new
    refute order_item.valid?
    assert_equal order_item.errors[:menu_item_id], ["can't be blank"]
  end

  test "requires quantity" do
    order_item = OrderItem.new
    refute order_item.valid?
    assert_equal order_item.errors[:quantity], ["can't be blank"]
  end

  test "quantity must be 1 or more" do
    order_item = OrderItem.new(quantity: 0)
    refute order_item.valid?
    assert_equal order_item.errors[:quantity], ["must be 1 or more"]
  end
end
