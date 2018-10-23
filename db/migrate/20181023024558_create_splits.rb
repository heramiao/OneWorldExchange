class CreateSplits < ActiveRecord::Migration[5.2]
  def change
    create_table :splits do |t|
      t.string :description
      t.string :split_type
      t.float :split_factor
      t.float :total_split_amount
      t.string :split_currency_type
      t.date :charge_date
      t.date :pay_date

      t.timestamps
    end
  end
end
