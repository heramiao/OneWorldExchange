class CreateConversions < ActiveRecord::Migration[5.2]
  def change
    create_table :conversions do |t|
      t.float :converted_amount
      t.float :exchange_rate
      t.datetime :date_time

      t.timestamps
    end
  end
end
