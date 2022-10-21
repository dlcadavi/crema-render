class AddFieldsToCourseattendances < ActiveRecord::Migration[7.0]
  def change
    add_column :courseattendances, :hours, :float
    add_column :courseattendances, :total_activities, :float
    add_column :courseattendances, :perc_attendance, :float
  end
end
