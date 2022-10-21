class AddFieldsToGraduations < ActiveRecord::Migration[7.0]
  def change
    add_column :graduations, :graduation_date, :date
    add_column :graduations, :grades, :float
  end
end
