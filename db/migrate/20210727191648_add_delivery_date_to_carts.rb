class AddDeliveryDateToCarts < ActiveRecord::Migration[6.1]
  def change
    add_column :carts, :delivery_date, :datetime
  end
end
