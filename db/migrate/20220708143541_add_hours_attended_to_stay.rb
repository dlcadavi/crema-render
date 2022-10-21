class AddHoursAttendedToStay < ActiveRecord::Migration[7.0]
  def change
    add_column :stays, :hours_attended, :float
  end
end
