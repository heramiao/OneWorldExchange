class AddUserToSplits < ActiveRecord::Migration[5.2]
  def change
    add_reference :splits, :user, foreign_key: true
  end
end
