class Category < ApplicationRecord
  has_ancestry
  has_many :product_categories, dependent: false
  has_many :products, through: :product_categories

  validates :name, uniqueness: true
  validates :name, presence: true

  enum status: { enable: 0, disable: 1 }
end
