require 'test_helper'

class UserViewsCustomersTest < ActionDispatch::IntegrationTest
  test "when there are no customers" do
    visit root_path
    click_on "Customers"
    assert page.has_content?("There are no customers.")
    refute page.has_content?("Sort")
  end

  test "viewing the full list of customers, in alphabetical order" do
    Customer.create(name: "Zena", phone: "6155241234")
    Customer.create(name: "Jennifer", phone: "1234567890")
    Customer.create(name: "Paul Revere", phone: "9318675309")
    visit root_path
    click_on "Customers"
    within("ul#customers li:nth-child(1)") do
      assert page.has_content?("Jennifer")
      assert page.has_content?("(123) 456-7890")
    end
    within("ul#customers li:nth-child(2)") do
      assert page.has_content?("Paul Revere")
      assert page.has_content?("(931) 867-5309")
    end
    within("ul#customers li:nth-child(3)") do
      assert page.has_content?("Zena")
      assert page.has_content?("(615) 524-1234")
    end
  end
end
