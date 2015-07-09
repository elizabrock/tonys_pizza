require 'test_helper'

class UserCreatesMenuItemsTest < ActionDispatch::IntegrationTest
  test "Customer creation happy path" do
    visit '/'
    click_on "Menu Items"
    click_on "Add New Item"
    fill_in "Name", with: "Cheese Pizza"
    fill_in "Price", with: "5.49"
    attach_file "Image", Rails.root.join("test", "fixtures", "cheese_pizza.jpg")
    click_on "Add Item"
    assert page.has_css?(".notice", text: "Cheese Pizza ($5.49) has been saved")
    assert_equal current_path, menu_items_path
    within("ul#menu_items") do
      assert page.has_css?("img[src='/uploads/cheese_pizza.jpg']")
      assert page.has_content?("Cheese Pizza")
      assert page.has_content?("$5.49")
    end
  end

  test "Customer creation error page" do
    visit '/'
    click_on "Menu Items"
    click_on "Add New Item"
    fill_in "Name", with: ""
    fill_in "Price", with: "five"
    click_on "Add Item"
    assert page.has_css?(".alert", text: "Menu item could not be saved")
    assert_equal "five", page.field_labeled("Price").value
    assert page.has_css?(".error.price", text: "must be a number")
    assert_equal "", page.field_labeled("Name").value
    assert page.has_css?(".error.name", text: "can't be blank")
    # It's important to test that we can fix the form and resubmit it.
    # Breaking the form is a surprisingly common bug!
    fill_in "Name", with: "Pepperoni Pizza"
    fill_in "Price", with: "7.89"
    click_on "Add Item"
    assert page.has_css?(".notice", text: "Pepperoni Pizza ($7.89) has been saved")
    assert_equal current_path, menu_items_path
    within("ul#menu_items") do
      assert page.has_css?("img[src='/images/placeholder_menu_item.jpg']")
      assert page.has_content?("Pepperoni Pizza")
      assert page.has_content?("$7.89")
    end
  end
end
