class AddDescriptionToVisits < ActiveRecord::Migration[7.0]
  def change
    add_column :visits, :description, :string
  end
end
