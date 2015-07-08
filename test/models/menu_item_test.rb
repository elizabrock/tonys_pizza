require 'test_helper'

class MenuItemTest < ActiveSupport::TestCase
  def sample_file
    @sample_file ||= File.open(Rails.root.join("test", "fixtures", "cheese_pizza.jpg"))
  end

  test "requires name" do
    menu_item = MenuItem.new(price: 5.49, image: sample_file)
    refute menu_item.valid?
    assert_equal menu_item.errors[:name], ["can't be blank"]
  end

  test "requires price" do
    menu_item = MenuItem.new(name: "Cheese Pizza", image: sample_file)
    refute menu_item.valid?
    assert_equal menu_item.errors[:price], ["can't be blank"]
  end

  test "requires price to be a number" do
    menu_item = MenuItem.new(name: "Cheese Pizza", price: "apples", image: sample_file)
    refute menu_item.valid?
    assert_equal menu_item.errors[:price], ["must be a number"]
  end

  test "saves image files to the filesystem" do
    menu_item = MenuItem.create(name: "Cheese Pizza", price: 5.49, image: sample_file)
    uploaded_file = File.open(menu_item.image_location)
    # Returns true if the contents of both files are identical.
    assert FileUtils.identical?(uploaded_file, sample_file)
  end

  test "image_path returns the URL path to the image" do
    menu_item = MenuItem.create(name: "Cheese Pizza", price: 5.49, image: sample_file)
    assert_equal menu_item.image_path, "/uploads/cheese_pizza.jpg"
  end

  test "image_path returns default image if there is no uploaded image" do
    menu_item = MenuItem.create(name: "Cheese Pizza", price: 5.49)
    assert_equal menu_item.image_path, "/images/placeholder_menu_item.jpg"
  end

  test "image_location returns the filesystem path to the image" do
    menu_item = MenuItem.create(name: "Cheese Pizza", price: 5.49, image: sample_file)
    assert_equal menu_item.image_location, Rails.root.join('public', 'uploads', 'cheese_pizza.jpg')
  end

  test "image_location returns nil if there is no image" do
    menu_item = MenuItem.create(name: "Cheese Pizza", price: 5.49)
    assert_nil menu_item.image_location
  end
end
