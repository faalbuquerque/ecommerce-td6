class Product < ApplicationRecord
  enum status: { active: 0 }
  enum fragile: { negative: 0, positive: 1 }

  has_many :product_categories, dependent: false
  has_many :categories, through: :product_categories

  has_many :evaluations, dependent: false

  has_one_attached :product_picture

  validates :name, :brand, :price, :length, :width, :height, :weight,
            :description, :sku, :product_picture, :fragile, :categories, presence: true

  validates :sku, uniqueness: true

  def calc_rate
    evaluated = evaluations.where(rate: 1..)
    sum = evaluated.sum(:rate)
    rate_count = evaluated.count
    update(average_rating: sum / rate_count) if rate_count.positive?
  end
end
