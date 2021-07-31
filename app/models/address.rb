class Address < ApplicationRecord
  belongs_to :user
  validates :state, :city, :cep, :neighborhood, :street, :number, presence: true
  has_many :carts, dependent: :destroy

  geocoded_by :address_string
  after_validation :geocode

  def display_address
    "#{street} - #{number} - #{neighborhood} - #{city} - #{state} - #{cep}"
  end

  def building_str
    "#{street}, #{number}, #{neighborhood}, #{city}/#{state}"
  end
end
