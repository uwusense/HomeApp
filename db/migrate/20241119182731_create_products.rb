class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :description, null: false
      t.string :category, null: false
      t.string :photo_url
      t.string :condition, null: false
      t.string :availability, null: false

      t.timestamps
    end

    add_reference :products, :user, null: false, foreign_key: true

    add_index :products, :condition
    add_index :products, :availability
    add_index :products, :created_at
    add_index :products, :price
    add_index :products, :category
  end
end
