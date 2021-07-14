class AddColumnsToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :brand, :string
    add_column :products, :price, :decimal
    add_column :products, :description, :string
    add_column :products, :height, :decimal
    add_column :products, :width, :decimal
    add_column :products, :length, :decimal
    add_column :products, :weight, :decimal
    add_column :products, :fragile, :boolean
    add_column :products, :status, :integer, null: false, default: 0
  end
end
