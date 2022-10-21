class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.string :context
      t.string :typology
      t.string :professor
      t.float :cost

      t.timestamps
    end
  end
end
