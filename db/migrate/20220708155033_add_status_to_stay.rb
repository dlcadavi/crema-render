class AddStatusToStay < ActiveRecord::Migration[7.0]
  def change
    add_column :stays, :attendance_status, :string
    add_column :stays, :cumulativegrades_status, :string
    add_column :stays, :periodgrades_status, :string
  end
end
