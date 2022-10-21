class AddAcyearToActivities < ActiveRecord::Migration[7.0]
  def change
    add_reference :activities, :acyear, null: true, foreign_key: true
  end
end
