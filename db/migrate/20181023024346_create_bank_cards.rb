class CreateBankCards < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_cards do |t|
      t.string :card_num
      t.date :expiration_date
      t.string :security_code

      t.timestamps
    end
  end
end
