require 'test_helper'

class UserEditsOrderTest < ActionDispatch::IntegrationTest
  def setup
    Customer.create(name: "Kate Braddock", phone: "9087654321")
    eliza = Customer.create(name: "Eliza Marcum", phone: "1234567890")
    @order = Order.create(customer: eliza, delivery_time: "2016-08-25 09:00AM", location: "TBD", notes: "Foo")
    visit orders_path
    click_on "August 25, 2016 09:00, Eliza Marcum"
    click_on "Edit Order"
  end

  test "Order edit happy path" do
    select "Kate Braddock", from: "Customer"
    # Must fill in date inputs with this date format with Capybara/Racktest.
    # Actual users can use their local date format:
    assert_equal "2016-08-25T09:00:00", field_labeled("Delivery Time").value
    fill_in "Delivery Time", with: "2016-08-25T13:00"
    assert_equal "TBD", field_labeled("Location").value
    fill_in "Location", with: "Neverland"
    assert_equal "Foo", field_labeled("Notes").value
    fill_in "Notes", with: ""
    click_on "Save Changes"
    assert page.has_css?(".notice", text: "Kate Braddock's order for August 25, 2016 13:00 has been updated.")
    assert_equal current_path, order_path(@order)
    assert page.has_content?("Kate Braddock")
    assert page.has_content?("August 25, 2016")
    assert page.has_content?("13:00")
    assert page.has_content?("Neverland")
    refute page.has_content?("Foo")
  end

  test "Order edit sad path" do
    select "", from: "Customer"
    # Must fill in date inputs with this date format with Capybara/Racktest.
    # Actual users can use their local date format:
    fill_in "Delivery Time", with: "2014-08-25T13:00"
    fill_in "Location", with: ""
    fill_in "Notes", with: ""
    click_on "Save Changes"
    assert page.has_css?(".alert", text: "The order could not be updated")
    assert_equal "2014-08-25T13:00:00", page.field_labeled("Delivery Time").value
    assert_equal "", page.field_labeled("Location").value
    assert page.has_css?(".error.location", text: "can't be blank")
    assert_equal "", page.field_labeled("Customer").value
    assert page.has_css?(".error.customer_id", text: "can't be blank")
    # It's important to test that we can fix the form and resubmit it.
    # Breaking the form is a surprisingly common bug!
    select "Kate Braddock", from: "Customer"
    # Must fill in date inputs with this date format with Capybara/Racktest.
    # Actual users can use their local date format:
    fill_in "Delivery Time", with: "2016-04-25T14:00"
    fill_in "Location", with: "Neverland"
    fill_in "Notes", with: "Bar"
    click_on "Save Changes"
    assert page.has_css?(".notice", text: "Kate Braddock's order for April 25, 2016 14:00 has been updated.")
    assert_equal current_path, order_path(@order)
    assert page.has_content?("Kate Braddock")
    assert page.has_content?("April 25, 2016")
    assert page.has_content?("14:00")
    assert page.has_content?("Neverland")
    assert page.has_content?("Bar")
  end
end
