class AddServiceToCart < ActiveRecord::Migration[6.1]
  def change
    add_column :carts, :service_order, :string
  end
end
