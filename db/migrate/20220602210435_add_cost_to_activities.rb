class AddCostToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :cost, :float
  end
end
