require 'test_helper'

class UserEditsMenuItemsTest < ActionDispatch::IntegrationTest
  def sample_file
    @sample_file ||= File.open(Rails.root.join("test", "fixtures", "cheese_pizza.jpg"))
  end

  test "Customer edit happy path" do
    menu_item = MenuItem.create(name: "Cheese Pizza", price: 5.49, image: sample_file)
    visit menu_items_path
    click_on "Cheese Pizza"
    fill_in "Name", with: "Pepperoni Pizza"
    fill_in "Price", with: "7.56"
    attach_file "Image", Rails.root.join("test", "fixtures", "pepperoni_pizza.jpg")
    click_on "Save Changes"
    assert page.has_css?(".notice", text: "Pepperoni Pizza ($7.56) has been updated.")
    assert_equal current_path, menu_items_path
    refute page.has_content?("Cheese Pizza")
    within("ul#menu_items") do
      assert page.has_css?("img[src='/uploads/pepperoni_pizza.jpg']")
      assert page.has_content?("Pepperoni Pizza")
      assert page.has_content?("$7.56")
    end
  end

  test "original image is preserved if a new image isn't uploaded" do
    menu_item = MenuItem.create(name: "Cheese Pizza", price: 5.49, image: sample_file)
    visit menu_items_path
    click_on "Cheese Pizza"
    fill_in "Name", with: "Pepperoni Pizza"
    fill_in "Price", with: "7.56"
    click_on "Save Changes"
    assert page.has_css?(".notice", text: "Pepperoni Pizza ($7.56) has been updated.")
    assert_equal current_path, menu_items_path
    within("ul#menu_items") do
      assert page.has_css?("img[src='/uploads/cheese_pizza.jpg']")
      assert page.has_content?("Pepperoni Pizza")
      assert page.has_content?("$7.56")
    end
  end

  test "Customer edit error path" do
    menu_item = MenuItem.create(name: "Cheese Pizza", price: 5.49, image: sample_file)
    visit menu_items_path
    click_on "Cheese Pizza"
    fill_in "Name", with: ""
    fill_in "Price", with: ""
    click_on "Save Changes"
    assert page.has_css?(".alert", text: "Your changes could not be saved.")
    assert_equal "", page.field_labeled("Price").value
    assert page.has_css?(".error.price", text: "can't be blank")
    assert_equal "", page.field_labeled("Name").value
    assert page.has_css?(".error.name", text: "can't be blank")
    # It's important to test that we can fix the form and resubmit it.
    # Breaking the form is a surprisingly common bug!
    fill_in "Name", with: "Pepperoni Pizza"
    fill_in "Price", with: "7.89"
    attach_file "Image", Rails.root.join("test", "fixtures", "pepperoni_pizza.jpg")
    click_on "Save Changes"
    assert page.has_css?(".notice", text: "Pepperoni Pizza ($7.89) has been updated.")
    assert_equal current_path, menu_items_path
    within("ul#menu_items") do
      assert page.has_content?("Pepperoni Pizza")
      assert page.has_content?("$7.89")
      assert page.has_css?("img[src='/uploads/pepperoni_pizza.jpg']")
    end
  end
end
