class AddListingTypeToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :listing_type, :string, null: false, default: "sell"
  end
end
