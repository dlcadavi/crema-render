class AddConfirmedDateToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :confirmed_date, :boolean
  end
end
