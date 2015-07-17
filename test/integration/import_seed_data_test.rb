require 'test_helper'

class ImportSeedDataTest < ActionDispatch::IntegrationTest
  test "importing seed data causes no errors" do
    # This test ensures that we don't accidently break the ability to run
    # db:seed in the future.  This is especially important for this project,
    # because the project will be the first Rails app for readers of Head First
    # Rails Development.
    load "#{Rails.root}/db/seeds.rb"
    assert_equal Customer.count, 6
    assert_equal MenuItem.count, 4
  end
end
