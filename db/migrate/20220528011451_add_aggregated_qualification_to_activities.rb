class AddAggregatedQualificationToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :aggregated_qualification, :string
   end
end
