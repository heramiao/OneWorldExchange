class AddForeignKeys < ActiveRecord::Migration[5.2]
  def change
    add_reference :group_members, :users, foreign_key: true
    add_reference :group_members, :travel_groups, foreign_key: true

    add_reference :trips, :travel_groups, foreign_key: true
    add_reference :trips, :transactions, foreign_key: true
  end
end
