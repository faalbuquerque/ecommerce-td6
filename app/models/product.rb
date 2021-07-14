class Product < ApplicationRecord
  enum status: { active: 0 }

  has_one_attached :product_picture
end
