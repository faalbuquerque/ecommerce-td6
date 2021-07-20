class Category < ApplicationRecord
  has_ancestry
  has_many :product_categories
  has_many :products, through: :product_categories

  enum status: { enable: 0, disable: 1 }
  #validates :name, uniqueness: true
end
