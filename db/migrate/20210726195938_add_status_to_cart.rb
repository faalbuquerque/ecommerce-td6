class AddStatusToCart < ActiveRecord::Migration[6.1]
  def change
    add_column :carts, :status, :integer, null: false, default: 0
  end
end
