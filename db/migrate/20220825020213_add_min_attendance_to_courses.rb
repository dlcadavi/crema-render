class AddMinAttendanceToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :min_attendance, :float
  end
end
