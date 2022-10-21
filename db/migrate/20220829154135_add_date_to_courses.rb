class AddDateToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :date, :datetime
  end
end
