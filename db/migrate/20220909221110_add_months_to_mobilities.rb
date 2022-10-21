class AddMonthsToMobilities < ActiveRecord::Migration[7.0]
  def change
    add_column :mobilities, :months, :float
  end
end
