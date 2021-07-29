class CreateReturns < ActiveRecord::Migration[6.1]
  def change
    create_table :returns do |t|
      t.integer :status, default: 0, null: false
      t.references :cart, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
