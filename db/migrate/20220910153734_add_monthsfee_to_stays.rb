class AddMonthsfeeToStays < ActiveRecord::Migration[7.0]
  def change
    add_column :stays, :monthsfee, :float
  end
end
