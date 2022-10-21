class AddNumberactivitiesToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :numberactivities, :integer
  end
end
