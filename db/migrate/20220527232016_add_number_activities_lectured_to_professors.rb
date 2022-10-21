class AddNumberActivitiesLecturedToProfessors < ActiveRecord::Migration[7.0]
  def change
    add_column :professors, :number_activities_lectured, :integer
  end
end
