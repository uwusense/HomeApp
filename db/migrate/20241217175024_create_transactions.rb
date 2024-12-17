class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :wallet, null: false, foreign_key: true
      t.string :amount
      t.string :transaction_type
      t.string :description

      t.timestamps
    end
  end
end
