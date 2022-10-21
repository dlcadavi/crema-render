class AddQualificationToProfessors < ActiveRecord::Migration[7.0]
  def change
    add_column :professors, :qualification, :string
  end
end
