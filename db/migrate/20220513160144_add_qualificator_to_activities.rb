class AddQualificatorToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :qualificator, :string
  end
end
