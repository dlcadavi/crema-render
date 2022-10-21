class AddHoursLecturedToProfessors < ActiveRecord::Migration[7.0]
  def change
    add_column :professors, :hours_lectured, :integer
  end
end
