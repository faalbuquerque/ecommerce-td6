class RemoveQuantityFromCart < ActiveRecord::Migration[6.1]
  def change
    remove_column :carts, :quantity, :integer
  end
end
