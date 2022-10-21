class AddSubtitleToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :subtitle, :string
  end
end
