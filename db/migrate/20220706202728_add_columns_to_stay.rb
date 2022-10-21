class AddColumnsToStay < ActiveRecord::Migration[7.0]
  def change
    add_column :stays, :hosting_start_date, :date
    add_column :stays, :hosting_end_date, :date
    add_column :stays, :ear_enrollment, :string
    add_column :stays, :fee, :float
    add_column :stays, :periodgrades, :float
    add_column :stays, :cumulativegrades, :float
    add_column :stays, :fee_reduction_request, :boolean
    add_column :stays, :firsttime, :boolean
  end
end
