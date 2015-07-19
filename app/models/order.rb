class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items

  validates_presence_of :customer_id, :delivery_time, :location
  validate :delivery_time_must_be_in_the_future

  default_scope { order(:delivery_time) }

  def total
    total = 0
    order_items.each do |order_item|
      total += order_item.total
    end
    total
  end

  private

  def delivery_time_must_be_in_the_future
    return unless delivery_time.present?
    unless self.delivery_time > Time.now
      errors[:delivery_time] << "must be in the future"
    end
  end
end
