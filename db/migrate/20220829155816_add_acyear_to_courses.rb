class AddAcyearToCourses < ActiveRecord::Migration[7.0]
  def change
    add_reference :courses, :acyear, null: true, foreign_key: true
  end
end
