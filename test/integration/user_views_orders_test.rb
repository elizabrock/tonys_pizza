require 'test_helper'

class UserViewsOrdersTest < ActionDispatch::IntegrationTest
  test "messaging when there are no orders" do
    visit root_path
    click_on "Orders"
    assert page.has_content?("There are no orders.")
  end

  test "view the list of orders, in order of date" do
    customer1 = Customer.create(name: "Susan Jones", phone: "1234567890")
    customer2 = Customer.create(name: "Julia Child", phone: "1234567890")
    customer3 = Customer.create(name: "Paul Revere", phone: "9318675309")
    Order.create(customer: customer2, delivery_time: "02/02/2016 5:00PM", location: "66 Orange Grove Way")
    Order.create(customer: customer1, delivery_time: "01/01/2016 12:00PM", location: "1000 Radio Lane")
    Order.create(customer: customer3, delivery_time: "03/03/2016 12:30AM", location: "28 Granny White Pike")
    visit root_path
    click_on "Orders"
    within("ul#orders li:nth-child(1)") do
      assert page.has_content?("Susan Jones")
      assert page.has_content?("January 01, 2016 12:00")
    end
    within("ul#orders li:nth-child(2)") do
      assert page.has_content?("Julia Child")
      assert page.has_content?("February 02, 2016 17:00")
    end
    within("ul#orders li:nth-child(3)") do
      assert page.has_content?("Paul Revere")
      assert page.has_content?("March 03, 2016 00:30")
    end
  end
end
