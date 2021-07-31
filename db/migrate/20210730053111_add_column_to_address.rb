class AddColumnToAddress < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :address_string, :string
  end
end
