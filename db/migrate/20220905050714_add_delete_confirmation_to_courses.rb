class AddDeleteConfirmationToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :deleteconfirmation, :integer
  end
end
