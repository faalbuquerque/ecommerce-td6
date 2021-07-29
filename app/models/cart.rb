class Cart < ApplicationRecord
  belongs_to :product
  belongs_to :user, optional: true
  belongs_to :address, optional: true

  validates :product_id, :shipping_id, presence: true

  enum status: { approved: 0, delivered: 1 }
  def set_quantity
    self.quantity = 1 if quantity.blank?
  end

  def elegible_for_return
    self.delivery_date && self.delivery_date > 8.days.ago
  end
end
