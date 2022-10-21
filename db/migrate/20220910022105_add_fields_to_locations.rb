class AddFieldsToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :start_location_date, :date
    add_column :locations, :end_location_date, :date
    add_column :locations, :fee, :float
    add_column :locations, :room, :string
    add_column :locations, :description, :string
    add_column :locations, :months, :float
  end
end
