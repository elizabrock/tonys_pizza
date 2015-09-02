# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

rosalyn = Customer.find_or_create_by(name: "Rosalyn Gardener", phone: "3084643532")
marcel = Customer.find_or_create_by(name: "Marcel Alduino",   phone: "5099513556")
Customer.find_or_create_by(name: "Phillipa Beutel",  phone: "8028047623")
Customer.find_or_create_by(name: "Corrina Brooks",   phone: "5075357010")
Customer.find_or_create_by(name: "Gladys Whitaker",  phone: "3307398145")
Customer.find_or_create_by(name: "Carmella Tyson",   phone: "4124522429")

MenuItem.find_or_create_by(name: "Marinara Sauce", price: 0.99)

cheese_pizza = MenuItem.find_or_create_by(name: "Cheese Pizza", price: 12.99)
cheese_pizza.image = File.open(Rails.root.join("test", "fixtures", "cheese_pizza.jpg"))
cheese_pizza.save

cheese_pizza_slice = MenuItem.find_or_create_by(name: "Slice of Cheese Pizza", price: 2.99)
cheese_pizza_slice.image = File.open(Rails.root.join("test", "fixtures", "cheese_slice.jpg"))
cheese_pizza_slice.save

pepperoni_pizza = MenuItem.find_or_create_by(name: "Pepperoni Pizza", price: 14.99)
pepperoni_pizza.image = File.open(Rails.root.join("test", "fixtures", "pepperoni_pizza.jpg"))
pepperoni_pizza.save

Order.create(customer: rosalyn, delivery_time: 2.days.from_now, location: "23 Nightingale Lane", notes: "This is for a surprise party.  Don't show up early!")
Order.create(customer: marcel, delivery_time: 2.weeks.from_now, location: "247 3rd St. South")
