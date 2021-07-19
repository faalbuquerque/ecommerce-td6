class Category < ApplicationRecord
  belongs_to :category, optional: true

  has_many :product_categories
  has_many :products, through: :product_categories

  has_many :subcategories,
            foreign_key: "subcategory_id"

  enum status: { enable: 0, disable: 1 }
end
