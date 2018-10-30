class AddPasswordConfirmationEntity < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password_confirmation, :string
  end
end
