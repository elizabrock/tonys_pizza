require 'test_helper'

# * CD orders (w/ date, location, etc.)
class UserCreatesOrderTest < ActionDispatch::IntegrationTest
  test "order creation when there are no orders" do
    visit '/'
    click_on "Orders"
    click_on "Add New Order"
    assert page.has_css?(".alert", text: "Orders cannot be created until customer information has been entered.")
    assert current_path, orders_path
  end

  test "order creation happy path" do
    Customer.create(name: "Bob Elder", phone: "1234567890")
    Customer.create(name: "Julia Child", phone: "1234567890")
    visit '/'
    click_on "Orders"
    click_on "Add New Order"
    select "Julia Child", from: "Customer"
    # Must fill in date inputs with this date format with Capybara/Racktest.
    # Actual users can use their local date format:
    fill_in "Delivery Time", with: "2020-02-20T13:00"
    fill_in "Location", with: "1000 Radio Lane"
    fill_in "Notes", with: "For child's birthday party"
    click_on "Create Order"
    assert page.has_css?(".notice", text: "Julia Child's order has been created.")
    assert_equal current_path, order_path(Order.last)
    assert page.has_content?("Julia Child")
    assert page.has_content?("February 20, 2020")
    assert page.has_content?("13:00")
    assert page.has_content?("1000 Radio Lane")
    assert page.has_content?("For child's birthday party")
  end

  test "order creation sad path" do
    Customer.create(name: "Bob Elder", phone: "1234567890")
    Customer.create(name: "Julia Child", phone: "1234567890")
    visit '/'
    click_on "Orders"
    click_on "Add New Order"
    # Must fill in date inputs with this date format with Capybara/Racktest.
    # Actual users can use their local date format:
    fill_in "Delivery Time", with: "2014-02-20T01:00"
    click_on "Create Order"

    assert page.has_css?(".alert", text: "The order could not be saved")
    # The date input's value is in this date format with Capybara/Racktest.
    # Actual users see it in their local date format:
    assert_equal "2014-02-20T01:00:00", page.field_labeled("Delivery Time").value
    assert page.has_css?(".error.delivery_time", text: "must be in the future")
    assert_equal "", page.field_labeled("Location").value
    assert page.has_css?(".error.location", text: "can't be blank")
    assert_equal "", page.field_labeled("Customer").value
    assert page.has_css?(".error.customer_id", text: "can't be blank")

    # It's important to test that we can fix the form and resubmit it.
    # Breaking the form is a surprisingly common bug!

    select "Bob Elder", from: "Customer"
    # Must fill in date inputs with this date format with Capybara/Racktest.
    # Actual users can use their local date format:
    fill_in "Delivery Time", with: "2016-06-22T2:00"
    fill_in "Location", with: "1444 Summerfield Lane"
    # Skipping filling in Notes, as they *shouldn't* be required.
    click_on "Create Order"
    assert page.has_css?(".notice", text: "Bob Elder's order has been created.")
    assert_equal current_path, order_path(Order.last)
    assert page.has_content?("Bob Elder")
    assert page.has_content?("June 22, 2016")
    assert page.has_content?("2:00")
    assert page.has_content?("1444 Summerfield Lane")
  end
end
