class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :state
      t.string :city
      t.string :cep
      t.string :neighborhood
      t.string :street
      t.string :number
      t.string :details

      t.timestamps
    end
  end
end
