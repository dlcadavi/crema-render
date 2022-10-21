class AddStudentToStays < ActiveRecord::Migration[7.0]
  def change
    add_reference :stays, :student
  end
end
