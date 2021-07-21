class Address < ApplicationRecord
  belongs_to :user
  has_many :carts

  def display_address
    'Cidade - Estado'
  end
end
