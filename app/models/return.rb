class Return < ApplicationRecord
  belongs_to :user
  belongs_to :cart
  enum status: { waiting: 0, delivering: 5, delivered: 10 }
end
