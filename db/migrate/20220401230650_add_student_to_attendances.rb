class AddStudentToAttendances < ActiveRecord::Migration[7.0]
  def change
    add_reference :attendances, :student
  end
end
