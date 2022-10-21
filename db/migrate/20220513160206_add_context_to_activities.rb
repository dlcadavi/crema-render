class AddContextToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :context, :string
  end
end
