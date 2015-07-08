require 'test_helper'

class UserViewsMenuItemsTest < ActionDispatch::IntegrationTest
  test "viewing the full list of menu items, in alphabetical order" do
    MenuItem.create(name: "Marinara Sauce", price: 0.99)
    cheese_pizza_image = File.open(Rails.root.join("test", "fixtures", "cheese_pizza.jpg"))
    MenuItem.create(name: "Cheese Pizza", price: 12.99, image: cheese_pizza_image)
    pepperoni_pizza_image = File.open(Rails.root.join("test", "fixtures", "pepperoni_pizza.jpg"))
    MenuItem.create(name: "Pepperoni Pizza", price: 14.99, image: pepperoni_pizza_image)
    visit root_path
    click_on "Menu Items"
    within("ul#menu_items li:nth-child(1)") do
      assert page.has_content?("Cheese Pizza")
      assert page.has_content?("$12.99")
      assert page.has_css?("img[src='/uploads/cheese_pizza.jpg']")
    end
    within("ul#menu_items li:nth-child(2)") do
      assert page.has_content?("Marinara Sauce")
      assert page.has_content?("$0.99")
      assert page.has_css?("img[src='/images/placeholder_menu_item.jpg']") #There should be no marinara sauce image
    end
    within("ul#menu_items li:nth-child(3)") do
      assert page.has_content?("Pepperoni Pizza")
      assert page.has_content?("$14.99")
      assert page.has_css?("img[src='/uploads/pepperoni_pizza.jpg']")
    end
  end

  test "sorting menu items by price" do
    MenuItem.create(name: "Marinara Sauce", price: 0.99)
    cheese_pizza_image = File.open(Rails.root.join("test", "fixtures", "cheese_pizza.jpg"))
    MenuItem.create(name: "Cheese Pizza", price: 14.99, image: cheese_pizza_image)
    pepperoni_pizza_image = File.open(Rails.root.join("test", "fixtures", "pepperoni_pizza.jpg"))
    MenuItem.create(name: "Pepperoni Pizza", price: 12.99, image: pepperoni_pizza_image)
    visit root_path
    click_on "Menu Items"
    # Page begins sorted by name
    assert page.has_css?(".sort .active", text: "Name")
    assert page.has_css?(".sort .inactive", text: "Price")
    assert page.has_css?("ul#menu_items li:nth-child(1)", text: "Cheese Pizza")
    assert page.has_css?("ul#menu_items li:nth-child(2)", text: "Marinara Sauce")
    assert page.has_css?("ul#menu_items li:nth-child(3)", text: "Pepperoni Pizza")
    click_link("Price")
    # Page is now sorted by price
    assert page.has_css?(".sort .inactive", text: "Name")
    assert page.has_css?(".sort .active", text: "Price")
    assert page.has_css?("ul#menu_items li:nth-child(1)", text: "Marinara Sauce")
    assert page.has_css?("ul#menu_items li:nth-child(2)", text: "Pepperoni Pizza")
    assert page.has_css?("ul#menu_items li:nth-child(3)", text: "Cheese Pizza")
    click_link("Name")
    # Page is now sorted by name
    assert page.has_css?(".sort .active", text: "Name")
    assert page.has_css?(".sort .inactive", text: "Price")
    assert page.has_css?("ul#menu_items li:nth-child(1)", text: "Cheese Pizza")
    assert page.has_css?("ul#menu_items li:nth-child(2)", text: "Marinara Sauce")
    assert page.has_css?("ul#menu_items li:nth-child(3)", text: "Pepperoni Pizza")
  end
end
