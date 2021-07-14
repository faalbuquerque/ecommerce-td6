class Product < ApplicationRecord
  enum status: { active: 0 }
  enum fragile: { negative: 0, positive: 1 }

  has_one_attached :product_picture
end
