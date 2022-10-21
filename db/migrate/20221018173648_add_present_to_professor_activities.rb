class AddPresentToProfessorActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :professoractivities, :present, :boolean
  end
end
