class FixDurationInActivities < ActiveRecord::Migration[7.0]
  def change
    change_column :activities, :duration, :decimal
  end
end
