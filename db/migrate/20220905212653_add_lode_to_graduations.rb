class AddLodeToGraduations < ActiveRecord::Migration[7.0]
  def change
    add_column :graduations, :lode, :boolean
  end
end
