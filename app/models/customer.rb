class Customer < ActiveRecord::Base
  validates_presence_of :name, :phone
  validates_length_of :phone, is: 10, allow_blank: true, message: "must be 10 digits"
  before_validation :format_phone_number

  private

  def format_phone_number
    if phone_changed?
      self.phone = self.phone.gsub(/[^\d]/, "")
    end
  end
end
