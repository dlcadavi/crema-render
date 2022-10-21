class AddTotalEnrollmentsToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :total_enrollments, :integer
  end
end
