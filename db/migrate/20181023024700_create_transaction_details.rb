class CreateTransactionDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_details do |t|
      t.string :expense_type
      t.string :country

      t.timestamps
    end
  end
end
