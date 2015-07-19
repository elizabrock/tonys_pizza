require 'test_helper'

class UserViewsOrderTest < ActionDispatch::IntegrationTest
  def setup
    customer = Customer.create(name: "Julia Child", phone: "1234567890")
    @order = Order.create(customer: customer, delivery_time: "02/02/2016 5:00PM", location: "66 Orange Grove Way")
  end

  test "viewing order details shows all customer and order information" do
    visit order_path(@order)
    within(".order") do
      assert page.has_content?("Julia Child")
      assert page.has_content?("(123) 456-7890")
      assert page.has_content?("February 02, 2016 17:00")
      assert page.has_content?("66 Orange Grove Way")
    end
  end

  test "viewing order details when there are no items in the order" do
    visit order_path(@order)
    assert page.has_content?("There are no items in this order.")
  end

  test "viewing order details, in alphabetical order, when there are items in the order" do
    visit order_path(@order)
    skip "until order items are added"
  end
end
