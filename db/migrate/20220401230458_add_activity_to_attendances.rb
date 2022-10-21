class AddActivityToAttendances < ActiveRecord::Migration[7.0]
  def change
     add_reference :attendances, :activity
  end
end
