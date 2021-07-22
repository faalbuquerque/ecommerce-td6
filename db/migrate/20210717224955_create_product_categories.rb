class CreateProductCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :product_categories do |t|
      t.references :product, null: false, foreign_key: true
      t.references :subcategory, null: false, foreign_key: { to_table: :categories }

      t.timestamps
    end
  end
end
