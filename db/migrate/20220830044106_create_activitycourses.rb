class CreateActivitycourses < ActiveRecord::Migration[7.0]
  def change
    create_table :activitycourses do |t|
      t.references :activity, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
