class RemoveQualificatorFromActivities < ActiveRecord::Migration[7.0]
  def change
    remove_column :activities, :qualificator, :string
  end
end
