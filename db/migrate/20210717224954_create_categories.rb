class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :status
      t.references :subcategory, foreign_key: { to_table: :categories }

      t.timestamps
    end
  end
end
