class AddGrantToStays < ActiveRecord::Migration[7.0]
  def change
    add_column :stays, :grant, :boolean
  end
end
