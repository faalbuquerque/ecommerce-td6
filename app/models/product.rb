class Product < ApplicationRecord
  enum status: { active: 0 }
  enum fragile: { negative: 0, positive: 1 }

  has_many :product_categories
  has_many :subcategories, class_name: "Category",
                           foreign_key: "subcategory_id",
                           through: :product_categories

  has_one_attached :product_picture

  validates :name, :brand, :price, :length, :width, :height, :weight,
            :description, :sku, :product_picture, :fragile, presence: true

  validates :sku, uniqueness: true
end
