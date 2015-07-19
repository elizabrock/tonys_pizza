require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "requires customer" do
    order = Order.new
    refute order.valid?
    assert_equal order.errors[:customer_id], ["can't be blank"]
  end

  test "requires delivery time in future" do
    order = Order.new(delivery_time: Date.today)
    refute order.valid?
    assert_equal order.errors[:delivery_time], ["must be in the future"]
  end

  test "requires delivery time" do
    order = Order.new
    refute order.valid?
    assert_equal order.errors[:delivery_time], ["can't be blank"]
  end

  test "requires location" do
    order = Order.new
    refute order.valid?
    assert_equal order.errors[:location], ["can't be blank"]
  end

  test "#total when there are no line items" do
    order = Order.new
    assert_equal 0, order.total
  end

  test "#total combines order_item totals" do
    menu_item1 = MenuItem.new(price: 3.50)
    menu_item2 = MenuItem.new(price: 1.00)
    order = Order.new
    order.order_items.build(quantity: 1, menu_item: menu_item1)
    order.order_items.build(quantity: 3, menu_item: menu_item2)
    assert_equal 6.50, order.total
  end
end
