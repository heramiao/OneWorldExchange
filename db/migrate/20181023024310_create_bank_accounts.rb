class CreateBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
      t.string :routing_num
      t.string :account_num

      t.timestamps
    end
  end
end
