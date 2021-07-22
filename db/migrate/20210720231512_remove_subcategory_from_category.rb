class RemoveSubcategoryFromCategory < ActiveRecord::Migration[6.1]
  def change
    remove_column :categories, :subcategory_id
  end
end
