class CreateSplits < ActiveRecord::Migration[5.2]
  def change
    create_table :splits do |t|
      t.float :percent_owed
      t.float :amount_owed
      t.date :date_paid
      t.references :transactions, foreign_key: true

      t.timestamps
    end
  end
end
