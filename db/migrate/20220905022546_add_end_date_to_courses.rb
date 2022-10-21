class AddEndDateToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :end_date, :datetime
  end
end
