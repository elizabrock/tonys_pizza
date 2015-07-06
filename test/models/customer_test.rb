require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  test "requires name" do
    customer = Customer.new(phone: "1234567890")
    refute customer.valid?
    assert_equal customer.errors[:name], ["can't be blank"]
  end

  test "requires phone number" do
    customer = Customer.new(name: "Joan Fellows")
    refute customer.valid?
    assert_equal customer.errors[:phone], ["can't be blank"]
  end

  test "requires phone number with 10 digits" do
    customer = Customer.new(name: "Joan Fellows", phone: "1234567")
    refute customer.valid?
    assert_equal customer.errors[:phone], ["must be 10 digits"]
  end

  test "new phone numbers are converted to numbers without punctuation" do
    customer = Customer.new(name: "Veronica Miller", phone: "(123)456-7890")
    assert_equal customer.phone, "(123)456-7890"
    customer.save
    assert_equal customer.phone, "1234567890"
  end

  test "updated phone numbers are converted to numbers without punctuation" do
    customer = Customer.create(name: "Veronica Miller", phone: "(123)456-7890")
    customer.phone = "(615)867-5309"
    customer.save
    assert_equal customer.phone, "6158675309"
  end
end
