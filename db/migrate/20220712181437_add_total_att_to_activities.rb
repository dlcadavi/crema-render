class AddTotalAttToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :total_attendances, :integer
    add_column :activities, :students_enrolled, :string
    add_column :activities, :students_attendance, :string
  end
end
