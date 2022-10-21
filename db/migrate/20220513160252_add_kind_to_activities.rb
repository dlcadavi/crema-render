class AddKindToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :kind, :integer
  end
end
