class CreateProfessoractivities < ActiveRecord::Migration[7.0]
  def change
    create_table :professoractivities do |t|
      t.integer :professor_id
      t.integer :activity_id

      t.timestamps
    end
  end
end
