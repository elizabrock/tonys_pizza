require 'test_helper'

class UserAddsItemsToOrderTest < ActionDispatch::IntegrationTest
  def setup
    MenuItem.create(name: "Marinara Sauce", price: 0.99)
    cheese_pizza_image = File.open(Rails.root.join("test", "fixtures", "cheese_pizza.jpg"))
    MenuItem.create(name: "Cheese Pizza", price: 12.99, image: cheese_pizza_image)
    pepperoni_pizza_image = File.open(Rails.root.join("test", "fixtures", "pepperoni_pizza.jpg"))
    @pepperoni_pizza = MenuItem.create(name: "Pepperoni Pizza", price: 14.99, image: pepperoni_pizza_image)
    customer = Customer.create(name: "Julia Child", phone: "1234567890")
    @order = Order.create!(customer: customer, delivery_time: "02/02/2020 5:00PM", location: "66 Orange Grove Way")
    visit order_path(@order)
  end

  test "happy path adding an item to an order" do
    click_on "Add to Order"
    select "Pepperoni Pizza", from: "Menu Item"
    fill_in "Quantity", with: "12"
    click_on "Add Item to Order"
    assert page.has_css?(".notice", text: "Pepperoni Pizza has been added to the order")
    assert_equal order_path(@order), current_path
    within("ul#order_items") do
      assert page.has_content?("12")
      assert page.has_content?("Pepperoni Pizza")
      assert page.has_content?("$179.88")
    end
  end

  test "sad path adding an item to an order" do
    click_on "Add to Order"
    select "", from: "Menu Item"
    fill_in "Quantity", with: "0"
    click_on "Add Item to Order"
    assert page.has_css?(".alert", text: "Item could not be added.")
    assert_equal "0", page.field_labeled("Quantity").value
    assert page.has_css?(".error.quantity", text: "must be 1 or more")
    assert_equal "", page.field_labeled("Menu Item").value
    assert page.has_css?(".error.menu_item_id", text: "can't be blank")
    # It's important to test that we can fix the form and resubmit it.
    # Breaking the form is a surprisingly common bug!
    select "Marinara Sauce", from: "Menu Item"
    fill_in "Quantity", with: "2"
    click_on "Add Item to Order"
    assert page.has_css?(".notice", text: "Marinara Sauce has been added to the order")
    assert_equal order_path(@order), current_path
    within("ul#order_items") do
      assert page.has_content?("2")
      assert page.has_content?("Marinara Sauce")
      assert page.has_content?("$1.98")
    end
  end

  test "adding a duplicate item to an order" do
    @order.order_items.create(menu_item: @pepperoni_pizza, quantity: 3)
    click_on "Add to Order"
    select "Pepperoni Pizza", from: "Menu Item"
    fill_in "Quantity", with: "12"
    click_on "Add Item to Order"
    assert page.has_css?(".notice", text: "Pepperoni Pizza has been added to the order")
    assert_equal order_path(@order), current_path
    within("ul#order_items") do
      assert page.has_content?("12")
      assert page.has_content?("$179.88")
      assert page.has_content?("3")
      assert page.has_content?("$44.97")
    end
  end
end
