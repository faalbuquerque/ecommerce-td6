class AddColumnsToCart < ActiveRecord::Migration[6.1]
  def change
    add_reference :carts, :user, null: true, foreign_key: true
    add_reference :carts, :address, null: true, foreign_key: true
    add_column :carts, :shipping_id, :string
    add_column :carts, :shipping_name, :string
    add_column :carts, :shipping_price, :decimal
    add_column :carts, :shipping_distance, :decimal
    add_column :carts, :shipping_time, :date
    add_column :carts, :latitude, :string
    add_column :carts, :longitude, :string
  end
end
