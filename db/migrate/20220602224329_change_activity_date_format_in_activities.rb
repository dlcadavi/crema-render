class ChangeActivityDateFormatInActivities < ActiveRecord::Migration[7.0]
  def up
    change_column :activities, :activity_date, :datetime
  end

  def down
    change_column :activities, :activity_date, :date
  end
end
