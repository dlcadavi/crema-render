class AddTotalfeeToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :totalfee, :float
  end
end
