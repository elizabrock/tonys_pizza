require 'test_helper'

class UserEditsCustomerTest < ActionDispatch::IntegrationTest
  test "Customer edit happy path" do
    Customer.create(name: "Veronica Mars", phone: "4508675309")
    visit customers_path
    click_on "Veronica Mars"
    fill_in "Name", with: "Jane Doe"
    fill_in "Phone Number", with: "123-456-7890"
    click_on "Save Changes"
    assert page.has_css?(".notice", text: "Jane Doe has been updated.")
    assert_equal current_path, customers_path
    refute page.has_content?("Veronica Mars")
    within("ul#customers") do
      assert page.has_content?("Jane Doe")
      assert page.has_content?("(123) 456-7890")
    end
  end

  test "Customer edit error path" do
    Customer.create(name: "Veronica Mars", phone: "4508675309")
    visit customers_path
    click_on "Veronica Mars"
    fill_in "Name", with: ""
    fill_in "Phone Number", with: "123-456"
    click_on "Save Changes"
    assert page.has_css?(".alert", text: "Customer could not be updated")
    assert_equal "123456", page.field_labeled("Phone Number").value
    assert page.has_css?(".error.phone", text: "must be 10 digits")
    assert_equal "", page.field_labeled("Name").value
    assert page.has_css?(".error.name", text: "can't be blank")
    # It's important to test that we can fix the form and resubmit it.
    # Breaking the form is a surprisingly common bug!
    fill_in "Name", with: "LaShonda Smith"
    fill_in "Phone Number", with: "123-456-7890"
    click_on "Save Changes"
    assert page.has_css?(".notice", text: "LaShonda Smith has been updated.")
    assert_equal current_path, customers_path
    within("ul#customers") do
      assert page.has_content?("LaShonda Smith")
      assert page.has_content?("(123) 456-7890")
    end
  end
end
