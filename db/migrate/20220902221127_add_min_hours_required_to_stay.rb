class AddMinHoursRequiredToStay < ActiveRecord::Migration[7.0]
  def change
    add_column :stays, :min_hours_required, :float
  end
end
