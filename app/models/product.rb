class Product < ApplicationRecord
  enum status: { active: 0 }
  enum fragile: { negative: 0, positive: 1 }

  has_many :product_categories, dependent: false
  has_many :categories, through: :product_categories

  has_many :evaluations, dependent: false

  has_one_attached :product_picture

  validates :name, :brand, :price, :length, :width, :height, :weight,
            :description, :sku, :product_picture, :fragile, presence: true

  validates :sku, uniqueness: true
end
