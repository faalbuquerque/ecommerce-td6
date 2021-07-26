class Cart < ApplicationRecord
  belongs_to :product
  belongs_to :user, optional: true
  belongs_to :address, optional: true

  validates :product_id, :shipping_id, presence: true
end
