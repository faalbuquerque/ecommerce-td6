class Evaluation < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :rate, :user_id, :product_id, presence: true
end
