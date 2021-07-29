class Cart < ApplicationRecord
  belongs_to :product
  belongs_to :user, optional: true
  belongs_to :address, optional: true

  validates :product_id,  presence: true #:shipping_id,

  enum status: { pending: 0, success: 1, delivered: 5 }
end
