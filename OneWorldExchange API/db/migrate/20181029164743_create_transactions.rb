class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.date :date_charged
      t.string :description
      t.string :currency_type
      t.float :total_charged
      t.string :country
      t.string :expense_type
      t.references :travel_groups, foreign_key: true

      t.timestamps
    end
  end
end
