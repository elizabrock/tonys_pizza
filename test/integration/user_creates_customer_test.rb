require 'test_helper'

class UserCreatesCustomerTest < ActionDispatch::IntegrationTest
  test "Customer creation happy path" do
    visit '/'
    click_on "Customers"
    click_on "Add New Customer"
    fill_in "Name", with: "Jane Doe"
    fill_in "Phone Number", with: "123-456-7890"
    click_on "Create Customer"
    assert page.has_css?(".notice", text: "Jane Doe has been saved")
    assert_equal current_path, customers_path
  end

  test "Customer creation error page" do
    visit '/'
    click_on "Customers"
    click_on "Add New Customer"
    fill_in "Name", with: ""
    fill_in "Phone Number", with: "123-456"
    click_on "Create Customer"
    assert page.has_css?(".alert", text: "Customer could not be saved")
    assert_equal "123456", page.field_labeled("Phone Number").value
    assert page.has_css?(".error.phone", text: "must be 10 digits")
    assert_equal "", page.field_labeled("Name").value
    assert page.has_css?(".error.name", text: "can't be blank")
    # It's important to test that we can fix the form and resubmit it.
    # Breaking the form is a surprisingly common bug!
    fill_in "Name", with: "LaShonda Smith"
    fill_in "Phone Number", with: "123-456-7890"
    click_on "Create Customer"
    assert page.has_css?(".notice", text: "LaShonda Smith has been saved")
    assert_equal current_path, customers_path
  end
end
