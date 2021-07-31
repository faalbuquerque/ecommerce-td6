class Cart < ApplicationRecord
  belongs_to :product
  belongs_to :user, optional: true
  belongs_to :address, optional: true

  validates :product_id, presence: true
  validates :service_order, presence: true, if: :status_delivered?

  enum status: { pending: 0, success: 1, delivered: 5 }

  def status_delivered?
    self.success?
  end

  def elegible_for_return
    delivery_date && delivery_date > 8.days.ago
  end
end
