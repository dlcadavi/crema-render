class AddUserAStudents < ActiveRecord::Migration[7.0]
  def change
    add_reference :students, :user, null: true, foreign_key: true
  end
end
