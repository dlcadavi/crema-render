class CreateProfessorcourses < ActiveRecord::Migration[7.0]
  def change
    create_table :professorcourses do |t|
      t.integer :professor_id
      t.integer :course_id

      t.timestamps
    end
  end
end
