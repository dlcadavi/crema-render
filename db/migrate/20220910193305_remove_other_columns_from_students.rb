class RemoveOtherColumnsFromStudents < ActiveRecord::Migration[7.0]
  def change
    remove_column :students, :city_of_birth
  end
end
