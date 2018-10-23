class CreateTravelGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :travel_groups do |t|
      t.string :trip_name
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
