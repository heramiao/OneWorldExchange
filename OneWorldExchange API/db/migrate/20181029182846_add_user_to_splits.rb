class AddUserToSplits < ActiveRecord::Migration[5.2]
  def change
    add_column :splits, :payee_id, :integer
    add_column :splits, :payor_id, :integer
    add_index :splits, :payee_id
    add_index :splits, :payor_id
  end
end
