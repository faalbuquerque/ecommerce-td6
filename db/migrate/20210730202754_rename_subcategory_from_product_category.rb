class RenameSubcategoryFromProductCategory < ActiveRecord::Migration[6.1]
  def change
    rename_column :product_categories, :subcategory_id, :category_id
  end
end
