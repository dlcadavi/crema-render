class AddNumberActivitiesAttendedToStay < ActiveRecord::Migration[7.0]
  def change
    add_column :stays, :number_activities_attended, :integer
  end
end
