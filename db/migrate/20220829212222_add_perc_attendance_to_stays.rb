class AddPercAttendanceToStays < ActiveRecord::Migration[7.0]
  def change
    add_column :stays, :perc_attendance, :float
  end
end
