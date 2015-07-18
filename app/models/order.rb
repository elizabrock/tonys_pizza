class Order < ApplicationRecord
  belongs_to :customer

  validates_presence_of :customer_id, :delivery_time, :location
  validate :delivery_time_must_be_in_the_future

  private

  def delivery_time_must_be_in_the_future
    return unless delivery_time.present?
    unless self.delivery_time > Time.now
      errors[:delivery_time] << "must be in the future"
    end
  end
end
