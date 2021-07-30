class AddWarehouseToCart < ActiveRecord::Migration[6.1]
  def change
    add_column :carts, :warehouse_code, :string
  end
end
