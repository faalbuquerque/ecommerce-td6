class ProductCategory < ApplicationRecord
  belongs_to :product
  belongs_to :subcategory, class_name: "Category", foreign_key: "subcategory_id"
end
