class AddRateToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :average_rating, :decimal
  end
end
