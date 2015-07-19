require 'test_helper'

class UserViewsOrderTest < ActionDispatch::IntegrationTest
  def setup
    customer = Customer.create(name: "Julia Child", phone: "1234567890")
    @order = Order.create(customer: customer, delivery_time: "02/02/2020 5:00PM", location: "66 Orange Grove Way")
  end

  test "viewing order details shows all customer and order information" do
    visit order_path(@order)
    assert page.has_content?("Julia Child")
    assert page.has_content?("(123) 456-7890")
    assert page.has_content?("February 02, 2020 17:00")
    assert page.has_content?("66 Orange Grove Way")
  end

  test "viewing order details when there are no items in the order" do
    visit order_path(@order)
    assert page.has_content?("There are no items in this order.")
  end

  test "viewing order details, in alphabetical order, when there are items in the order" do
    marinara_sauce = MenuItem.create(name: "Marinara Sauce", price: 0.99)
    cheese_pizza_image = File.open(Rails.root.join("test", "fixtures", "cheese_pizza.jpg"))
    cheese_pizza = MenuItem.create(name: "Cheese Pizza", price: 12.99, image: cheese_pizza_image)
    pepperoni_pizza = MenuItem.create(name: "Pepperoni Pizza", price: 14.99)
    @order.order_items.create(menu_item: marinara_sauce, quantity: 4)
    @order.order_items.create(menu_item: cheese_pizza, quantity: 1)
    @order.order_items.create(menu_item: pepperoni_pizza, quantity: 1)

    visit order_path(@order)
    refute page.has_content?("There are no items in this order.")
    within("table#order_items tbody tr:nth-child(1)") do
      assert page.has_content?("Cheese Pizza")
      assert page.has_css?(".menu_item_price", text: "$12.99")
      assert page.has_css?(".line_quantity", text: "1")
      assert page.has_css?(".line_total", text: "$12.99")
    end
    within("table#order_items tbody tr:nth-child(2)") do
      assert page.has_content?("Marinara Sauce")
      assert page.has_css?(".menu_item_price", text: "$0.99")
      assert page.has_css?(".line_quantity", text: "4")
      assert page.has_css?(".line_total", text: "$3.96")
    end
    within("table#order_items tbody tr:nth-child(3)") do
      assert page.has_content?("Pepperoni Pizza")
      assert page.has_css?(".menu_item_price", text: "$14.99")
      assert page.has_css?(".line_quantity", text: "1")
      assert page.has_css?(".line_total", text: "$14.99")
    end
  end
end
