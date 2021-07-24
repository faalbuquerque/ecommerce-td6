class Cart < ApplicationRecord
  belongs_to :product
  belongs_to :user, optional: true
  belongs_to :address, optional: true
  before_create :set_quantity

  enum status: { pending: 0, success: 1 }

  def set_quantity
    self.quantity = 1 if quantity.blank?
  end
end
