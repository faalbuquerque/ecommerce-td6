class Address < ApplicationRecord
  belongs_to :user
  validates :state, :city, :cep, :neighborhood, :street, :number, presence: true
  has_many :carts, dependent: :destroy

  def display_address
    "#{street} - #{number} - #{neighborhood} - #{city} - #{state} - #{cep}"
  end
end
