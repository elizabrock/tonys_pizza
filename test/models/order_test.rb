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
end
