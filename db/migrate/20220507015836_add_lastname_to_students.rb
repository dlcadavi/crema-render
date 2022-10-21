class AddLastnameToStudents < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :lastname, :string
  end
end
