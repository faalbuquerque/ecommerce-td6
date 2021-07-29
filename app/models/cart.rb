class Cart < ApplicationRecord
  belongs_to :product
  belongs_to :user, optional: true
  belongs_to :address, optional: true

  validates :product_id, presence: true

  enum status: { pending: 0, success: 1, delivered: 5 }

  def elegible_for_return
    delivery_date && delivery_date > 8.days.ago
  end
end
