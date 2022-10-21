class AddCostoToProfessoractivities < ActiveRecord::Migration[7.0]
  def change
    add_column :professoractivities, :cost, :float
  end
end
